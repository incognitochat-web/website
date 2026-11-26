#!/usr/bin/env bash
# Writes what the Donate page shows from Open Collective to the given JSON
# file: the collective's balance, its regular (monthly and yearly)
# donations, and the donations of the last 30 days. From Open Collective's
# public API, with no token.
#
#   scripts/fetch-collective.sh data/collective.json
#
# Amounts, dates and how often, nothing else: the API is never asked for a
# name, an account or a message, so a donor who later hides themselves on
# Open Collective leaves nothing behind here. Fetched at each deploy, never
# committed. Amounts are in cents of US dollars, the collective's currency.
# If the answer can't be read, or holds anything else, it writes {} and the
# page says it couldn't load them.
#
# Needs curl, jq and python3 (it reads the collective's name from hugo.toml).
set -euo pipefail

out=${1:?usage: $0 <output.json>}
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$(dirname "$out")"

slug=$(python3 -I -c 'import sys, tomllib; print(tomllib.load(open(sys.argv[1], "rb"))["params"]["openCollective"])' "$root/hugo.toml")
[[ $slug =~ ^[a-z0-9-]{1,64}$ ]] || { echo "params.openCollective in hugo.toml isn't a collective's name: '$slug'" >&2; exit 1; }

now=$(date -u +%Y-%m-%dT%H:%M:%SZ)
since=$(date -u -d "$now - 30 days" +%Y-%m-%dT%H:%M:%SZ)
jq -n --arg slug "$slug" --arg since "$since" '{
  query: "query($slug: String!, $since: DateTime!) { account(slug: $slug) { currency stats { balance { valueInCents currency } } orders(filter: INCOMING, status: [ACTIVE], frequency: [MONTHLY, YEARLY], limit: 1000) { totalCount nodes { frequency amount { valueInCents currency } } } transactions(type: CREDIT, kind: [CONTRIBUTION], dateFrom: $since, limit: 1000) { totalCount nodes { createdAt isRefunded amount { valueInCents currency } } } } }",
  variables: {slug: $slug, since: $since}
}' >"$tmp/query.json"

echo '{}' >"$tmp/out.json"
# Bounded: a slow or rate-limited API can't hold the deploy up.
if curl -sS --fail-with-body --connect-timeout 10 -m 30 --retry 2 --retry-all-errors --retry-max-time 60 -H 'Content-Type: application/json' \
  --data-binary "@$tmp/query.json" https://api.opencollective.com/graphql/v2 >"$tmp/answer.json" 2>"$tmp/curl.err"; then
  # Every part must be there and well formed, or nothing is shown: a part
  # missing would read as "no donations". Refunded donations are left out.
  jq --arg now "$now" '
    def cents: type == "number" and . == floor and . > -1e12 and . < 1e12;
    def usd: type == "object" and (.valueInCents | cents) and .currency == "USD";
    def day: type == "string" and test("\\A20[0-9]{2}-[0-9]{2}-[0-9]{2}T")
      and ((.[0:10] + "T00:00:00Z" | try fromdateiso8601 catch null) as $t | $t != null and ($t | strftime("%Y-%m-%d")) == .[0:10]);
    (.data.account // null) as $a
    | if .errors != null or ($a | type) != "object" or $a.currency != "USD"
        or ($a.stats.balance | usd | not) or $a.stats.balance.valueInCents < 0
        or ($a.orders.nodes | type) != "array" or $a.orders.totalCount != ($a.orders.nodes | length)
        or ($a.transactions.nodes | type) != "array" or $a.transactions.totalCount != ($a.transactions.nodes | length)
        or ([$a.orders.nodes[] | (.frequency == "MONTHLY" or .frequency == "YEARLY") and (.amount | usd) and .amount.valueInCents > 0] | all | not)
        or ([$a.transactions.nodes[] | (.createdAt | day) and (.isRefunded | type == "boolean") and (.amount | usd) and .amount.valueInCents > 0] | all | not)
      then {}
      else {
        as_of: $now,
        balance: $a.stats.balance.valueInCents,
        supporters: ([$a.orders.nodes[] | {frequency: (.frequency | ascii_downcase), amount: .amount.valueInCents}]
          | sort_by(.frequency, -.amount)),
        recent: ([$a.transactions.nodes[] | select(.isRefunded | not) | {date: .createdAt[0:10], amount: .amount.valueInCents}]
          | sort_by(.date, .amount) | reverse)
      } end' "$tmp/answer.json" >"$tmp/out.json" 2>/dev/null || echo '{}' >"$tmp/out.json"
fi
# Why, for the log: an API error is about the query, never about donors.
# (A GraphQL error can come with an HTTP error: its body is kept.)
if [ "$(jq -c . "$tmp/out.json")" = '{}' ]; then
  if api=$(jq -er 'select((.errors | type) == "array") | .errors[0].message // "" | tostring | .[0:200]' "$tmp/answer.json" 2>/dev/null); then
    why="the API answered with an error: $api"
  elif [ -s "$tmp/curl.err" ]; then
    why="Open Collective couldn't be reached: $(head -c 300 "$tmp/curl.err")"
  else
    why="the answer had an unexpected shape"
  fi
  # One plain line: a newline in it would start another workflow command.
  why=$(printf '%s' "$why" | tr -c '[:print:]' ' ')
fi
mv "$tmp/out.json" "$out"
if [ "$(jq -c . "$out")" = '{}' ]; then
  # A warning on the deploy's page, so it's seen; the deploy goes on.
  echo "::warning::collective: couldn't load (${why:-unknown}); the page says so"
else
  echo "collective: $(jq -r '"balance \(.balance) cents, \(.supporters | length) regular, \(.recent | length) in 30 days"' "$out")"
fi
