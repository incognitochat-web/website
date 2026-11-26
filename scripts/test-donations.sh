#!/usr/bin/env bash
# Tests the Donate page's numbers from Open Collective, offline:
# fetch-collective.sh against a stand-in curl (what it asks for, what it
# keeps, what it refuses), then the page Hugo builds from what it wrote:
# with numbers, with none, and without them. Touches nothing but a temporary
# folder. Needs hugo, jq and python3.
#
#   scripts/test-donations.sh
# shellcheck disable=SC2016 # the $ in the patterns are amounts, meant literally
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

# A copy of the site, so a test can change hugo.toml or the data.
cp -r "$root" "$work/site"
rm -rf "$work/site/public" "$work/site/data" "$work/site/.git" "$work/site/.stats-store" "$work/site/resources"
mkdir -p "$work/site/data"

# The stand-in curl: keeps its arguments and the request it was sent, then
# answers with the file in STUB_ANSWER, or fails like a network error with
# STUB_FAIL=1.
mkdir -p "$work/bin"
cat >"$work/bin/curl" <<'EOF'
#!/usr/bin/env bash
echo "$*" >"$STUB_ARGS"
while [ $# -gt 0 ]; do
  case $1 in --data-binary) cp "${2#@}" "$STUB_SENT"; shift 2 ;; *) shift ;; esac
done
[ "${STUB_FAIL:-}" != 1 ] || { echo "stand-in: unreachable" >&2; exit 7; }
cat "$STUB_ANSWER"
EOF
chmod +x "$work/bin/curl"
fetch() { # answer-file output-file
  PATH="$work/bin:$PATH" STUB_ARGS=$work/args STUB_SENT=$work/sent.json STUB_ANSWER=$1 \
    "$work/site/scripts/fetch-collective.sh" "$2" >/dev/null
}

# An answer with everything the page shows, and more than was asked for:
# names, which must never come out.
cat >"$work/answer.json" <<'EOF'
{"data":{"account":{"currency":"USD","stats":{"balance":{"valueInCents":123456,"currency":"USD"}},
 "orders":{"totalCount":3,"nodes":[
  {"frequency":"MONTHLY","amount":{"valueInCents":500,"currency":"USD"},"fromAccount":{"name":"Alice Example"}},
  {"frequency":"YEARLY","amount":{"valueInCents":10000,"currency":"USD"}},
  {"frequency":"MONTHLY","amount":{"valueInCents":2500,"currency":"USD"}}]},
 "transactions":{"totalCount":3,"nodes":[
  {"createdAt":"2026-11-20T10:00:00.000Z","isRefunded":false,"amount":{"valueInCents":1000,"currency":"USD"},"fromAccount":{"name":"Bob Example"}},
  {"createdAt":"2026-11-25T08:00:00.000Z","isRefunded":false,"amount":{"valueInCents":2500,"currency":"USD"}},
  {"createdAt":"2026-11-22T08:00:00.000Z","isRefunded":true,"amount":{"valueInCents":700,"currency":"USD"}}]}}}}
EOF
fetch "$work/answer.json" "$work/out.json"

# What it asks: Open Collective's API, for the collective in hugo.toml, the
# last 30 days, and nothing about who.
[[ $(cat "$work/args") == *"https://api.opencollective.com/graphql/v2"* ]] || fail "not Open Collective's API: $(cat "$work/args")"
slug=$(python3 -I -c 'import sys, tomllib; print(tomllib.load(open(sys.argv[1], "rb"))["params"]["openCollective"])' "$root/hugo.toml")
jq -e --arg slug "$slug" '.variables.slug == $slug' "$work/sent.json" >/dev/null || fail "it didn't ask for the collective in hugo.toml"
since=$(jq -r '.variables.since' "$work/sent.json")
d=$(($(date -u +%s) - $(date -u -d "$since" +%s) - 30 * 86400))
[ "${d#-}" -lt 120 ] || fail "not the last 30 days: from $since"
q=$(jq -r .query "$work/sent.json")
# (Its one account is the collective, by its name: account(slug: $slug).)
for word in name Account email description payee memo tags; do
  [[ $q != *"$word"* ]] || fail "the query asks for '$word': $q"
done

# What it keeps: the balance, each regular donation's amount and how often
# (biggest first, monthly ones first), each donation's day and amount
# (newest first, a refunded one left out), and the time it asked.
jq -e '(keys == ["as_of", "balance", "recent", "supporters"])
  and .balance == 123456
  and .supporters == [{frequency: "monthly", amount: 2500}, {frequency: "monthly", amount: 500}, {frequency: "yearly", amount: 10000}]
  and .recent == [{date: "2026-11-25", amount: 2500}, {date: "2026-11-20", amount: 1000}]
  and (.as_of | test("\\A20[0-9]{2}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\\z"))' "$work/out.json" >/dev/null \
  || fail "what it kept: $(jq -c . "$work/out.json")"
if grep -q 'Example' "$work/out.json"; then fail "a name came through"; fi

# What it refuses, writing {} (the page then says it couldn't load them),
# and the deploy goes on.
refused() { # name jq-change
  jq "$2" "$work/answer.json" >"$work/bad-answer.json"
  fetch "$work/bad-answer.json" "$work/bad.json" || fail "$1: the script failed instead of writing {}"
  [ "$(jq -c . "$work/bad.json")" = '{}' ] || fail "$1 was accepted: $(jq -c . "$work/bad.json")"
}
refused "an error" '.errors = [{message: "x"}]'
refused "no account" '.data.account = null'
refused "another currency" '.data.account.currency = "EUR"'
refused "a balance in another currency" '.data.account.stats.balance.currency = "EUR"'
refused "a balance that isn't a whole number" '.data.account.stats.balance.valueInCents = 1.5'
refused "a regular donation in another currency" '.data.account.orders.nodes[0].amount.currency = "EUR"'
refused "a weekly donation" '.data.account.orders.nodes[0].frequency = "WEEKLY"'
refused "a regular donation of nothing" '.data.account.orders.nodes[0].amount.valueInCents = 0'
refused "more regular donations than given" '.data.account.orders.totalCount = 4'
refused "more donations than given" '.data.account.transactions.totalCount = 4'
refused "a donation in another currency" '.data.account.transactions.nodes[0].amount.currency = "EUR"'
refused "a negative donation" '.data.account.transactions.nodes[0].amount.valueInCents = -100'
refused "a day that doesn't exist" '.data.account.transactions.nodes[0].createdAt = "2026-02-30T10:00:00.000Z"'
refused "no refund flag" 'del(.data.account.transactions.nodes[0].isRefunded)'
refused "no list" '.data.account.transactions.nodes = null'
echo 'not json' >"$work/bad-answer.json"
fetch "$work/bad-answer.json" "$work/bad.json" || fail "an unreadable answer failed the script"
[ "$(jq -c . "$work/bad.json")" = '{}' ] || fail "an unreadable answer was accepted"
STUB_FAIL=1 fetch "$work/answer.json" "$work/bad.json" 2>/dev/null || fail "an unreachable API failed the script"
[ "$(jq -c . "$work/bad.json")" = '{}' ] || fail "an unreachable API wrote something"
# A collective's name that could be anything else in hugo.toml: refused.
cp "$work/site/hugo.toml" "$work/hugo.toml.real"
sed -i 's/^  openCollective = .*/  openCollective = "a b"/' "$work/site/hugo.toml"
if fetch "$work/answer.json" "$work/bad.json" 2>/dev/null; then fail "a collective name with a space was used"; fi
cp "$work/hugo.toml.real" "$work/site/hugo.toml"

# The page.
build() { # collective.json-or-none output-dir
  rm -f "$work/site/data/collective.json"
  [ "$1" = none ] || cp "$1" "$work/site/data/collective.json"
  hugo --quiet --source "$work/site" --destination "$2" >/dev/null
}
build "$work/out.json" "$work/pub"
en=$(cat "$work/pub/donate/index.html")
[[ $en == *'<h1>Donations and costs</h1>'* ]] || fail "the page's title"
[[ $en == *'<p class="tile-value" dir="ltr">$1,234.56</p><p class="tile-name">Balance</p>'* ]] || fail "the balance tile"
[[ $en == *'<p class="tile-value">3</p><p class="tile-name">Regular supporters</p>'* ]] || fail "the regular supporters tile"
[[ $en == *'<p class="tile-value" dir="ltr">$30.00</p><p class="tile-name">Given each month</p>'* ]] || fail "the monthly total"
[[ $en == *'<p class="tile-value" dir="ltr">$100.00</p><p class="tile-name">Given each year</p>'* ]] || fail "the yearly total"
[[ $en == *'<li><span dir="ltr">$25.00</span> a month</li>'* ]] || fail "a regular donation's amount"
[[ $en == *'<li><span dir="ltr">$100.00</span> a year</li>'* ]] || fail "a yearly donation's amount"
[[ $en == *'<time datetime="2026-11-25">Nov 25, 2026</time></td><td dir="ltr">$25.00</td>'* ]] || fail "a donation's row"
[[ $en != *'$7.00'* ]] || fail "a refunded donation is shown"
[[ $en == *'href="https://opencollective.com/'"$slug"'/transactions"'* ]] || fail "no link to the donations on Open Collective"
[[ $en == *'<h2 id="costs">'* && $en == *'<h2 id="donations">'* ]] || fail "the sections' anchors"
if grep -rq 'Example' "$work/pub"; then fail "a name is on the site"; fi
# Newest first, and the regular ones in the order fetched.
[[ $en =~ 2026-11-25.*2026-11-20 ]] || fail "the donations aren't newest first"
# In German, the amounts its way; in Persian and Arabic, left to right.
de=$(cat "$work/pub/de/donate/index.html")
nbsp=$(printf '\302\240') # U+00A0, whatever the locale
[[ $de == *"dir=\"ltr\">1.234,56${nbsp}\$</p>"* ]] || fail "German balance isn't 1.234,56 \$"
for l in fa ar; do
  grep -q '<li><span dir="ltr">\$25.00</span>' "$work/pub/$l/donate/index.html" || fail "$l: an amount isn't kept left to right"
done
# No yearly donations: no yearly tile.
jq '.supporters |= map(select(.frequency == "monthly"))' "$work/out.json" >"$work/monthly.json"
build "$work/monthly.json" "$work/pub2"
if grep -q 'Given each year' "$work/pub2/donate/index.html"; then fail "a yearly tile with no yearly donations"; fi
# None yet: each part says so.
jq '.supporters = [] | .recent = []' "$work/out.json" >"$work/none.json"
build "$work/none.json" "$work/pub3"
grep -q 'No regular supporters yet.' "$work/pub3/donate/index.html" || fail "no regular supporters isn't said"
grep -q 'No donations in the last 30 days.' "$work/pub3/donate/index.html" || fail "no donations isn't said"
# Couldn't load ({} or no file): each part says so, and the site still builds.
echo '{}' >"$work/empty.json"
for data in "$work/empty.json" none; do
  build "$data" "$work/pub4"
  [ "$(grep -o "Couldn&#39;t load this from Open Collective just now." "$work/pub4/donate/index.html" | wc -l)" = 3 ] \
    || fail "without the numbers ($data), not every part says it couldn't load them"
done
# A part the shortcode doesn't know stops the build.
printf -- '---\ntitle: "x"\n---\n{{< collective "everything" >}}\n' >"$work/site/content/oc-bad.md"
if hugo --quiet --source "$work/site" --destination "$work/pub5" >/dev/null 2>&1; then fail "an unknown part was built"; fi
rm "$work/site/content/oc-bad.md"

echo "ok: donations"
