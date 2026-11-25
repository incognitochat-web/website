#!/usr/bin/env bash
# Tests the Status page offline: what it shows for the latest app checks
# (data/appcheck.json) and bot check (data/botcheck.json), and what
# scripts/fetch-bot-checks.sh takes from a stand-in GitHub CLI. Builds the
# site with Hugo into a temporary folder and touches nothing else. Needs
# hugo and jq.
#
#   scripts/test-status.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

# The site with the given app checks and bot check (JSON files), into the
# given folder.
build() { # appcheck.json output-dir [botcheck.json]
  rm -rf "$work/site"
  mkdir -p "$work/site"
  (cd "$root" && tar --exclude=./.git --exclude=./public --exclude=./data/appcheck.json --exclude=./data/botcheck.json \
    --exclude=./data/stats.json --exclude=./.stats-store --exclude=./resources -cf - .) | tar -xf - -C "$work/site"
  mkdir -p "$work/site/data"
  cp "$1" "$work/site/data/appcheck.json"
  if [ -n "${3:-}" ]; then cp "$3" "$work/site/data/botcheck.json"; fi
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
[ "$(grep -o 'Hasn&#39;t run yet.' <<<"$page" | wc -l)" = 3 ] || fail "no results: not every group (app hourly, daily, bot) says it hasn't run"

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

# The bot check: its group, its rows, and the banner it counts in.
bot_id=$(sed -nE 's/^ *botId = ([0-9]+)$/\1/p' "$root/hugo.toml")
bot=$(sed -nE 's/^ *botUsername = "([^"]+)"$/\1/p' "$root/hugo.toml")
[ -n "$bot_id" ] && [ -n "$bot" ] || fail "hugo.toml has no params.botId or params.botUsername"
botrun=https://github.com/example/site/actions/runs/2
jq -n --arg at "2026-11-25T10:41:00Z" --arg run "$botrun" --argjson id "$bot_id" \
  '{result: "passed", checked_at: $at, bot_id: $id, run_url: $run, checks: {bot: "passed", main: "passed", menu: "passed", welcome: "passed"}}' >"$work/bot-passed.json"
bot_section() { sed -n '/What the bot opens, every hour/,/<\/table>/p' "$1"; }

build "$work/none.json" "$work/out-bot-none"
grep -q 'What the bot opens, every hour' "$work/out-bot-none/status/index.html" || fail "no bot result: no bot group"
[[ $(bot_section "$work/out-bot-none/status/index.html") == *'Hasn&#39;t run yet.'* ]] || fail "no bot result: the bot group doesn't say it hasn't run"

build "$work/passed.json" "$work/out-bot-passed" "$work/bot-passed.json"
page=$(cat "$work/out-bot-passed/status/index.html")
section=$(bot_section "$work/out-bot-passed/status/index.html")
[[ $page == *'class="status-banner status-passed"'* ]] || fail "bot passed: the banner isn't 'passed'"
[ "$(grep -o 'class="st st-passed"' <<<"$section" | wc -l)" = 4 ] || fail "bot passed: not 4 passed bot rows"
[[ $section == *"href=\"$botrun\""* ]] || fail "bot passed: no link to the bot check's log"
[[ $section == *"@$bot is still the bot it was (Telegram ID $bot_id)"* ]] || fail "bot passed: the bot row doesn't name the bot and its ID"
[[ $section == *"t.me/$bot?startapp, which every Incognito Chat link uses"* ]] || fail "bot passed: the links row doesn't name the link"
[[ $page == *'Last checked <time datetime="2026-11-25T10:41:00Z"'* ]] || fail "bot passed: 'Last checked' isn't the newest check (the bot's)"

jq '.result = "failed" | .checks.main = "failed"' "$work/bot-passed.json" >"$work/bot-failed.json"
build "$work/passed.json" "$work/out-bot-failed" "$work/bot-failed.json"
page=$(cat "$work/out-bot-failed/status/index.html")
[[ $page == *'class="status-banner status-failed"'* ]] || fail "bot failed: the banner isn't 'failed'"
[ "$(grep -o 'class="st st-failed"' <<<"$(bot_section "$work/out-bot-failed/status/index.html")")" = 'class="st st-failed"' ] || fail "bot failed: not one failed bot row"

# Another Telegram ID under the same username: a new bot. Its own checks
# passing don't make it pass.
jq '.bot_id = 123456789' "$work/bot-passed.json" >"$work/bot-other.json"
build "$work/passed.json" "$work/out-bot-other" "$work/bot-other.json"
page=$(cat "$work/out-bot-other/status/index.html")
section=$(bot_section "$work/out-bot-other/status/index.html")
[[ $page == *'class="status-banner status-failed"'* ]] || fail "another bot ID: the banner isn't 'failed'"
[[ $(grep -A3 'The same bot' <<<"$section") == *'st st-failed'* ]] || fail "another bot ID: the bot row isn't failed"
[ "$(grep -o 'class="st st-passed"' <<<"$section" | wc -l)" = 3 ] || fail "another bot ID: the other bot rows changed"

# Couldn't finish, no ID read: an error, not a failure.
jq -n --arg at "2026-11-25T10:41:00Z" '{result: "error", checked_at: $at, bot_id: null, run_url: "https://github.com/example/site/actions/runs/3", checks: {bot: "unknown", main: "unknown", menu: "unknown", welcome: "unknown"}}' >"$work/bot-error.json"
build "$work/passed.json" "$work/out-bot-error" "$work/bot-error.json"
[[ $(cat "$work/out-bot-error/status/index.html") == *'class="status-banner status-error"'* ]] || fail "bot error: the banner isn't 'error'"

# The fetch scripts, with a stand-in gh: runs are "id[:event[:repository]]",
# newest first (event schedule and repository example/site if left out).
mkdir -p "$work/gh/bin" "$work/gh/artifacts"
cat >"$work/gh/bin/gh" <<'GH'
#!/usr/bin/env bash
case "$1 $2" in
  "api repos/"*)
    [[ $2 == *"?branch=main&status=completed&"* ]] || { echo "stand-in gh: unexpected query: $2" >&2; exit 1; }
    for r in $RUNS; do
      IFS=: read -r id event head <<<"$r"
      jq -n --argjson id "$id" --arg event "${event:-schedule}" --arg head "${head:-example/site}" \
        '{id: $id, event: $event, head_branch: "main", head_repository: {full_name: $head}}'
    done | jq -s '{workflow_runs: .}' ;;
  "run download")
    id=$3; name=$(sed -E 's/.* --name ([^ ]+).*/\1/' <<<"$*"); dir=$(sed -E 's/.* --dir ([^ ]+).*/\1/' <<<"$*")
    [ -f "$ARTIFACTS/$name-$id.json" ] || exit 1
    mkdir -p "$dir" && cp "$ARTIFACTS/$name-$id.json" "$dir/$name.json" ;;
  *) echo "stand-in gh: unexpected: $*" >&2; exit 1 ;;
esac
GH
chmod +x "$work/gh/bin/gh"
fetch() { # script, runs...
  local script=$1; shift
  PATH="$work/gh/bin:$PATH" RUNS="$*" ARTIFACTS="$work/gh/artifacts" GITHUB_REPOSITORY=example/site \
    "$root/scripts/$script" "$work/fetched.json" >/dev/null
}
a=$work/gh/artifacts
cp "$work/bot-passed.json" "$a/bot-check-10.json"
cp "$work/bot-failed.json" "$a/bot-check-9.json"
jq '.result = "maybe"' "$work/bot-passed.json" >"$a/bot-check-11.json"
jq '.checks.main = "<script>" | .checks.extra = "passed"' "$work/bot-failed.json" >"$a/bot-check-12.json"
jq '.bot_id = 1.5' "$work/bot-passed.json" >"$a/bot-check-13.json"
jq '.checked_at = "yesterday"' "$work/bot-passed.json" >"$a/bot-check-14.json"
jq '.bot_id = null' "$work/bot-passed.json" >"$a/bot-check-15.json"
cp "$work/bot-error.json" "$a/bot-check-16.json"
jq '.bot_id = 4503599627370496' "$work/bot-passed.json" >"$a/bot-check-17.json"
jq '.bot_id = 9007199254740992' "$work/bot-passed.json" >"$a/bot-check-18.json"
for fork in 30 31 32; do jq '.result = "passed" | .bot_id = 1' "$work/bot-passed.json" >"$a/bot-check-$fork.json"; done
# 20: no result (a skipped run); 11, 13, 14, 15 (passed without an ID), 18
# (over 2^53): malformed; 10: the newest good one, over the older 9.
fetch fetch-bot-checks.sh 20 11 13 14 15 18 10 9
jq -e --argjson id "$bot_id" '.result == "passed" and .bot_id == $id and .run_url == "https://github.com/example/site/actions/runs/10"
  and (.checks | keys) == ["bot", "main", "menu", "welcome"]' "$work/fetched.json" >/dev/null || fail "fetch: not the newest well-formed result: $(cat "$work/fetched.json")"
fetch fetch-bot-checks.sh 12
jq -e '.result == "failed" and (.checks | has("extra") | not) and (.checks | has("main") | not) and .checks.welcome == "passed"' "$work/fetched.json" >/dev/null \
  || fail "fetch: unknown checks or statuses weren't dropped: $(cat "$work/fetched.json")"
fetch fetch-bot-checks.sh 16
jq -e '.result == "error" and .bot_id == null' "$work/fetched.json" >/dev/null || fail "fetch: a run that couldn't finish, without an ID, wasn't taken"
fetch fetch-bot-checks.sh 17
jq -e '.bot_id == 4503599627370496' "$work/fetched.json" >/dev/null || fail "fetch: a 52-bit Telegram ID wasn't taken"
# A pull request's run, a fork's, or a push's isn't this repository's check.
fetch fetch-bot-checks.sh 30:pull_request 31:schedule:someone/site 32:push 9
jq -e '.result == "failed" and .run_url == "https://github.com/example/site/actions/runs/9"' "$work/fetched.json" >/dev/null \
  || fail "fetch: a pull request's, a fork's or a push's run was taken: $(cat "$work/fetched.json")"
fetch fetch-bot-checks.sh 31:workflow_dispatch:someone/site
[ "$(cat "$work/fetched.json")" = '{}' ] || fail "fetch: a fork's run was taken"
fetch fetch-bot-checks.sh 20 11
[ "$(cat "$work/fetched.json")" = '{}' ] || fail "fetch: no good result, but not {}"
fetch fetch-bot-checks.sh
[ "$(cat "$work/fetched.json")" = '{}' ] || fail "fetch: no runs, but not {}"

# The app checks' fetch too: a fork's "passed" doesn't hide this repository's failure.
jq '.hourly | .mode = "hourly"' "$work/passed.json" >"$a/app-check-40.json"
jq '.hourly | .mode = "hourly" | .result = "failed"' "$work/passed.json" >"$a/app-check-41.json"
fetch fetch-app-checks.sh 40:pull_request:someone/site 41
jq -e '.hourly.result == "failed" and .hourly.run_url == "https://github.com/example/site/actions/runs/41"' "$work/fetched.json" >/dev/null \
  || fail "fetch-app-checks: a fork's run was taken: $(cat "$work/fetched.json")"

# check-bot.yml: a run that leaves no result says it couldn't run.
python3 - "$root/.github/workflows/check-bot.yml" >"$work/note.sh" <<'PY'
import sys, yaml
steps = yaml.safe_load(open(sys.argv[1]))["jobs"]["check"]["steps"]
print(next(s["run"] for s in steps if s.get("name") == "Note a run that left no result"))
PY
mkdir -p "$work/runner"
: >"$work/genv"
RUNNER_TEMP="$work/runner" GITHUB_ENV="$work/genv" bash -e "$work/note.sh"
jq -e '.result == "error" and .bot_id == null and ([.checks[]] | unique) == ["unknown"]' "$work/runner/result/bot-check.json" >/dev/null \
  || fail "check-bot.yml: no error result for a run that left none"
grep -qx 'RESULT=error' "$work/genv" || fail "check-bot.yml: RESULT isn't error for a run that left no result"
cp "$work/bot-failed.json" "$work/runner/result/bot-check.json"
: >"$work/genv"
RUNNER_TEMP="$work/runner" GITHUB_ENV="$work/genv" bash -e "$work/note.sh"
jq -e '.result == "failed"' "$work/runner/result/bot-check.json" >/dev/null || fail "check-bot.yml: a real result was overwritten"
[ ! -s "$work/genv" ] || fail "check-bot.yml: RESULT changed for a run with a result"

echo "ok: status page"
