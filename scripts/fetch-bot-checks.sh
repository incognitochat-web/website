#!/usr/bin/env bash
# Writes the latest result of the bot check to the given JSON file, for the
# Status page. Reads the result that .github/workflows/check-bot.yml uploads
# with its runs (scripts/verify-bot.py's --summary, from the code repository).
#
#   scripts/fetch-bot-checks.sh data/botcheck.json
#
# Needs gh (GH_TOKEN with actions: read) and jq. With no result, or no
# access, it writes {} and the page says the check hasn't run yet.
set -euo pipefail

out=${1:?usage: $0 <output.json>}
repo=${GITHUB_REPOSITORY:-incognitochat-web/website}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$(dirname "$out")"
echo '{}' >"$tmp/latest.json"

# Only this repository's own runs, scheduled or started by hand: a pull
# request from a fork can name its branch main and change the workflow.
# GitHub is asked for those events alone, so other runs, however many, can't
# push them off the page. If either list can't be read, nothing is shown
# rather than an older result from the other.
runs=$(for event in schedule workflow_dispatch; do
    gh api "repos/${repo}/actions/workflows/check-bot.yml/runs?branch=main&event=${event}&status=completed&per_page=30" 2>/dev/null \
      || touch "$tmp/unread"
  done | jq -rs --arg repo "$repo" '[.[].workflow_runs[]?
      | select((.event == "schedule" or .event == "workflow_dispatch")
          and .head_branch == "main" and .head_repository.full_name == $repo)]
      | sort_by(-.id) | .[] | "\(.id) \(.conclusion // "-") \(.updated_at // "-")"' 2>/dev/null || true)
[ -e "$tmp/unread" ] && runs=""

# Newest first: the first run with a well-formed result. A run that failed,
# ran out of time or was cancelled without one couldn't check (a checkout or
# the install failed, say); one that succeeded without one was skipped (no
# login yet) and is passed over.
while read -r id conclusion updated; do
  [[ $id =~ ^[0-9]+$ ]] || continue
  url="https://github.com/${repo}/actions/runs/${id}"
  rm -rf "$tmp/run" "$tmp/next.json"
  if gh run download "$id" --repo "$repo" --name bot-check --dir "$tmp/run" >/dev/null 2>&1; then
    # Only well-formed values reach the page.
    jq --arg url "$url" '
      select(type == "object"
        and (.result == "passed" or .result == "failed" or .result == "error")
        and (.checked_at | type == "string" and test("\\A[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\\z"))
        # Telegram IDs fit in 52 bits; only a run that could not finish may lack one.
        and (if .bot_id == null then .result == "error"
             else (.bot_id | type == "number" and . == floor and . > 0 and . <= 9007199254740991) end))
      # Each check: a known name and a known status; anything else is dropped.
      | {result, checked_at, bot_id, run_url: $url,
         checks: (.checks // {} | if type == "object" then . else {} end
           | with_entries(select(
               (.key | IN("bot", "main", "menu", "welcome"))
               and (.value | IN("passed", "failed", "unknown", "na")))))}
    ' "$tmp/run/bot-check.json" >"$tmp/next.json" 2>/dev/null || true
  fi
  if [ -s "$tmp/next.json" ]; then
    mv "$tmp/next.json" "$tmp/latest.json"
    break
  fi
  case $conclusion in
    failure | timed_out | cancelled | startup_failure)
      [[ $updated =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z$ ]] || continue
      jq -n --arg at "$updated" --arg url "$url" \
        '{result: "error", checked_at: $at, bot_id: null, run_url: $url, checks: {bot: "unknown", main: "unknown", menu: "unknown", welcome: "unknown"}}' \
        >"$tmp/latest.json"
      break ;;
  esac
done <<<"$runs"

jq -S . "$tmp/latest.json" >"$out"
cat "$out"
