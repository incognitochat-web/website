#!/usr/bin/env bash
# Writes the latest result of each kind of app check (hourly; daily with a
# rebuild) to the given JSON file, for the Verify page. Reads the results
# that .github/workflows/check-app.yml uploads with its runs.
#
#   scripts/fetch-app-checks.sh data/appcheck.json
#
# Needs gh (GH_TOKEN with actions: read) and jq. With no results, or no
# access, it writes {} and the page says no check has run yet.
set -euo pipefail

out=${1:?usage: $0 <output.json>}
repo=${GITHUB_REPOSITORY:-incognitochat-web/website}
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$(dirname "$out")"
echo '{}' >"$tmp/all.json"

# Only this repository's own runs, scheduled or started by hand: a pull
# request from a fork can name its branch main and change the workflow.
runs=$(gh api "repos/${repo}/actions/workflows/check-app.yml/runs?branch=main&status=completed&per_page=60" 2>/dev/null \
  | jq -r --arg repo "$repo" '.workflow_runs[]
      | select((.event == "schedule" or .event == "workflow_dispatch")
          and .head_branch == "main" and .head_repository.full_name == $repo)
      | .id' 2>/dev/null || true)
for id in $runs; do
  [[ $id =~ ^[0-9]+$ ]] || continue
  [ "$(jq 'has("hourly") and has("rebuild")' "$tmp/all.json")" = true ] && break
  rm -rf "$tmp/run"
  gh run download "$id" --repo "$repo" --name app-check --dir "$tmp/run" >/dev/null 2>&1 || continue
  # Only well-formed values reach the page.
  jq --arg url "https://github.com/${repo}/actions/runs/${id}" --slurpfile all "$tmp/all.json" '
    select(type == "object"
      and (.mode == "hourly" or .mode == "rebuild")
      and (.result == "passed" or .result == "failed" or .result == "error")
      and (.checked_at | type == "string" and test("\\A[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}:[0-9]{2}Z\\z"))
      and (.ref | type == "string" and test("\\A(v[0-9]+\\.[0-9]+\\.[0-9]+|[0-9a-f]{40})?\\z")))
    | . as $r
    # Each check: a known name and a known status; anything else is dropped.
    | ($r.checks // {} | if type == "object" then . else {} end
        | with_entries(select(
            (.key | IN("address", "domain", "source", "latest", "signed", "deployed", "files", "rebuild"))
            and (.value | IN("passed", "failed", "warning", "unknown", "na"))))) as $checks
    | $all[0] | if has($r.mode) then . else .[$r.mode] = ($r | {result, checked_at, ref, checks: $checks, run_url: $url}) end
  ' "$tmp/run/app-check.json" >"$tmp/next.json" 2>/dev/null || continue
  [ -s "$tmp/next.json" ] && mv "$tmp/next.json" "$tmp/all.json"
done

jq -S . "$tmp/all.json" >"$out"
cat "$out"
