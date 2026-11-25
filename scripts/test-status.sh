#!/usr/bin/env bash
# Tests the Status page offline: what it shows for the latest app checks
# (data/appcheck.json). Builds the site with Hugo into a temporary folder
# and touches nothing else. Needs hugo and jq.
#
#   scripts/test-status.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

# The site with the given app checks (a JSON file), into the given folder.
build() { # appcheck.json output-dir
  rm -rf "$work/site"
  mkdir -p "$work/site"
  (cd "$root" && tar --exclude=./.git --exclude=./public --exclude=./data/appcheck.json --exclude=./data/stats.json \
    --exclude=./.stats-store --exclude=./resources -cf - .) | tar -xf - -C "$work/site"
  mkdir -p "$work/site/data"
  cp "$1" "$work/site/data/appcheck.json"
  hugo --quiet --source "$work/site" --destination "$2" >/dev/null
}

at=2026-11-25T10:17:00Z
run=https://github.com/example/site/actions/runs/1
all_hourly='{"address":"passed","domain":"passed","source":"passed","latest":"passed","signed":"passed","deployed":"passed","files":"passed"}'

# No check has run.
echo '{}' >"$work/none.json"
build "$work/none.json" "$work/out-none"
page=$(cat "$work/out-none/status/index.html")
[[ $page == *'class="status-banner status-none"'* ]] || fail "no results: the banner isn't 'none'"
[[ $page == *'No check has run yet'* ]] || fail "no results: the banner doesn't say no check has run"
[ "$(grep -o 'Hasn&#39;t run yet.' <<<"$page" | wc -l)" = 2 ] || fail "no results: not both groups say they haven't run"

# Both passed.
jq -n --arg at "$at" --arg run "$run" --argjson h "$all_hourly" '{
  hourly: {result: "passed", checked_at: $at, ref: "v2.12.0", checks: $h, run_url: $run},
  rebuild: {result: "passed", checked_at: $at, ref: "v2.12.0", checks: {rebuild: "passed"}, run_url: $run}}' >"$work/passed.json"
build "$work/passed.json" "$work/out-passed"
page=$(cat "$work/out-passed/status/index.html")
[[ $page == *'class="status-banner status-passed"'* ]] || fail "all passed: the banner isn't 'passed'"
[[ $page == *'All checks passed'* ]] || fail "all passed: the banner doesn't say so"
[[ $page == *'Last checked <time datetime="2026-11-25T10:17:00Z" dir="ltr">2026-11-25 10:17 UTC</time>'* ]] || fail "all passed: no 'Last checked' time"
[ "$(grep -o 'class="st st-passed"' <<<"$page" | wc -l)" = 8 ] || fail "all passed: not 8 passed rows"
[[ $page == *"<code>v2.12.0</code>"* ]] || fail "all passed: the version isn't shown"
[[ $page == *"href=\"$run\""* ]] || fail "all passed: no link to the run's log"
[[ $page == *'Every hour'* && $page == *'Every day'* ]] || fail "all passed: a group is missing"

# One failed, one couldn't run.
jq '.hourly.result = "failed" | .hourly.checks.files = "failed"' "$work/passed.json" >"$work/failed.json"
build "$work/failed.json" "$work/out-failed"
page=$(cat "$work/out-failed/status/index.html")
[[ $page == *'class="status-banner status-failed"'* && $page == *'A check failed'* ]] || fail "a failure: the banner doesn't say a check failed"
[ "$(grep -o 'class="st st-failed"' <<<"$page" | wc -l)" = 1 ] || fail "a failure: not one failed row"
jq '.rebuild.result = "error" | .rebuild.checks.rebuild = "unknown"' "$work/passed.json" >"$work/error.json"
build "$work/error.json" "$work/out-error"
page=$(cat "$work/out-error/status/index.html")
[[ $page == *'class="status-banner status-error"'* && $page == *'A check couldn&#39;t run'* ]] || fail "an error: the banner doesn't say a check couldn't run"

# Every language has the page.
for l in fa ru ar nl es pt-br id tr uk fr de pl; do
  [ -s "$work/out-passed/$l/status/index.html" ] || fail "no $l Status page"
done

echo "ok: status page"
