#!/usr/bin/env bash
# Tests the statistics pipeline end to end, offline: collect-stats.sh
# against a stand-in AWS CLI with known answers (and its refusals), a second
# run that must change nothing, build-stats.sh (and what it refuses), then
# Hugo, and checks what the Stats page shows, with numbers, with costs only,
# and with none. Touches nothing but a temporary folder. Needs hugo and jq.
#
#   scripts/test-stats.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

# The checks below compare hours and days the scripts and this test each
# work out from the clock: in an hour's last minute, wait for the next one.
if [ "$(date -u +%M)" = 59 ]; then sleep $((61 - 10#$(date -u +%S))); fi

# The stand-in: CloudWatch-shaped hours relative to the window asked for
# (none with STUB_EMPTY=1), and Cost Explorer-shaped days up to the End
# asked for (today included if asked: the script must not), in two pages.
mkdir -p "$work/bin"
cat >"$work/bin/aws" <<'EOF'
#!/usr/bin/env bash
args="$*"
start=$(sed -n 's/.*--start-time \([^ ]*\).*/\1/p' <<<"$args")
case $args in
  "cloudwatch get-metric-data"*)
    if [ "${STUB_EMPTY:-}" = 1 ]; then
      echo '{"MetricDataResults":[{"Id":"accounts","StatusCode":"Complete","Timestamps":[],"Values":[]},{"Id":"messages","StatusCode":"Complete","Timestamps":[],"Values":[]},{"Id":"media_bytes","StatusCode":"Complete","Timestamps":[],"Values":[]}]}'
      exit 0
    fi
    t1=$(date -u -d "$start + 3 hours" +%Y-%m-%dT%H:%M:%S+00:00)
    t2=$(date -u -d "$start + 167 hours" +%Y-%m-%dT%H:%M:%SZ)
    cat <<J
{"MetricDataResults":[
 {"Id":"accounts","StatusCode":"Complete","Timestamps":["$t1","$t2"],"Values":[2.0,5.0]},
 {"Id":"messages","StatusCode":"Complete","Timestamps":["$t2"],"Values":[7.0]},
 {"Id":"media_bytes","StatusCode":"Complete","Timestamps":["$t2"],"Values":[2113536.0]}]}
J
    ;;
  "ce get-cost-and-usage"*)
    end=$(sed -n 's/.*End=\([0-9-]*\).*/\1/p' <<<"$args")
    today=$(date -u +%Y-%m-%d)
    y=$(date -u -d yesterday +%Y-%m-%d)
    tday=''
    [[ $end > $today ]] && tday=",{\"TimePeriod\":{\"Start\":\"$today\"},\"Estimated\":true,\"Total\":{\"UnblendedCost\":{\"Amount\":\"9\",\"Unit\":\"USD\"}},\"Groups\":[{\"Keys\":[\"AWS Lambda\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"9\",\"Unit\":\"USD\"}}}]}"
    if [[ $args == *SERVICE* ]]; then
      if [[ $args != *--next-page-token* ]]; then
        # Page one: the day's first groups, and a token for the rest.
        echo "{\"NextPageToken\":\"page two\",\"ResultsByTime\":[{\"TimePeriod\":{\"Start\":\"$y\"},\"Estimated\":true,\"Groups\":[{\"Keys\":[\"<b>AWS Lambda</b>\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"0.25\",\"Unit\":\"USD\"}}},{\"Keys\":[\"AmazonCloudWatch\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"0.5\",\"Unit\":\"USD\"}}},{\"Keys\":[\"Amazon DynamoDB\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"0.125\",\"Unit\":\"USD\"}}}]}]}"
      else
        echo "{\"ResultsByTime\":[{\"TimePeriod\":{\"Start\":\"$y\"},\"Estimated\":true,\"Groups\":[{\"Keys\":[\"AWS WAF\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"1\",\"Unit\":\"USD\"}}},{\"Keys\":[\"Amazon Simple Storage Service\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"0.0625\",\"Unit\":\"USD\"}}},{\"Keys\":[\"AWS Key Management Service\"],\"Metrics\":{\"UnblendedCost\":{\"Amount\":\"0.0625\",\"Unit\":\"USD\"}}}]}$tday]}"
      fi
    else
      echo "{\"ResultsByTime\":[{\"TimePeriod\":{\"Start\":\"$y\"},\"Estimated\":true,\"Total\":{\"UnblendedCost\":{\"Amount\":\"0.03\",\"Unit\":\"USD\"}},\"Groups\":[]}$tday]}"
    fi ;;
  *) echo "stand-in aws: unexpected: $args" >&2; exit 1 ;;
esac
EOF
chmod +x "$work/bin/aws"

store=$work/store
mkdir -p "$store"
run() { PATH="$work/bin:$PATH" AWS_REGION=eu-west-1 NAMESPACE=test/api "$root/scripts/collect-stats.sh" "$@" >/dev/null; }
run counts "$store"
run costs production "$store"
run costs dev "$store"

# Known values land in the right hours; a second run (in the same hour)
# changes nothing.
end=$(date -u +%Y-%m-%dT%H:00:00Z)
start=$(date -u -d "$end - 168 hours" +%Y-%m-%dT%H:00:00Z)
h3=$(date -u -d "$start + 3 hours" +%Y-%m-%dT%H)
file=$store/stats/hourly/${h3:0:10}.json
[ "$(jq ".accounts[${h3:11:2} | tonumber]" "$file")" = 2 ] || fail "accounts not in the hour they were counted: $file"
cp -r "$store" "$work/before"
run counts "$store"
if [ "$(date -u +%Y-%m-%dT%H:00:00Z)" = "$end" ]; then
  diff -r "$work/before" "$store" >/dev/null || fail "a second run changed the store"
fi

# Costs: up to yesterday, never today; the two pages' groups put back together.
today=$(date -u +%Y-%m-%d)
yesterday=$(date -u -d yesterday +%Y-%m-%d)
if cat "$store"/stats/costs/*/*.json | jq -e --arg t "$today" 'select(.days | has($t))' >/dev/null; then
  fail "today's partial day was stored"
fi
jq -e --arg y "$yesterday" '.days[$y] | length == 6' "$store/stats/costs/production/${yesterday:0:7}.json" >/dev/null \
  || fail "the two pages' groups weren't put back together"

# No data point at all where the store has counts: refused, store untouched.
cp -r "$store" "$work/before2"
if STUB_EMPTY=1 run counts "$store" 2>/dev/null; then fail "an empty answer overwrote counts"; fi
diff -r "$work/before2" "$store" >/dev/null || fail "a refused run changed the store"
# But a quiet week whose only count is in the hour before the window is fine.
quiet=$work/quiet
mkdir -p "$quiet/stats/hourly"
pre=$(date -u -d "$start - 1 hour" +%Y-%m-%dT%H)
jq -n --arg d "${pre:0:10}" --argjson h "$((10#${pre:11:2}))" \
  '{date: $d, accounts: [range(24) as $i | if $i == $h then 1 else 0 end], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' \
  >"$quiet/stats/hourly/${pre:0:10}.json"
STUB_EMPTY=1 run counts "$quiet" || fail "a quiet week was refused"
# And when a stored file can't be read, it can't tell: refused.
broken=$work/broken
cp -r "$quiet" "$broken"
old=$(date -u -d "$start - 2 days" +%Y-%m-%d)
echo 'not json' >"$broken/stats/hourly/$old.json"
if STUB_EMPTY=1 run counts "$broken" 2>/dev/null; then fail "an unreadable stored file let an empty answer through"; fi

# A link in the store is refused, and nothing outside is read or written.
linked=$work/linked
mkdir -p "$linked/stats" "$work/outside"
echo '{"date":"x"}' >"$work/outside/${end:0:10}.json"
ln -s "$work/outside" "$linked/stats/hourly"
if run counts "$linked" 2>/dev/null; then fail "a linked folder was written through"; fi
[ "$(cat "$work/outside/${end:0:10}.json")" = '{"date":"x"}' ] || fail "a file outside the store changed"

"$root/scripts/build-stats.sh" "$store" "$work/stats.json" >/dev/null
jq -e '.last24.accounts == 5 and .last24.messages == 7 and .last24.media_bytes == 2113536' "$work/stats.json" >/dev/null \
  || fail "last 24 hours: $(jq -c .last24 "$work/stats.json")"
jq -e '.hours | length == 168' "$work/stats.json" >/dev/null || fail "not 168 hours"
jq -e '.costs.services == ["AWS WAF", "AmazonCloudWatch", "<b>AWS Lambda</b>", "Amazon DynamoDB", "Other"]' "$work/stats.json" >/dev/null \
  || fail "services: $(jq -c .costs.services "$work/stats.json")"
jq -e '.costs.days[-1].values == [1, 0.5, 0.25, 0.125, 0.125] and .costs.days[-1].dev == 0.03' "$work/stats.json" >/dev/null \
  || fail "a day's costs: $(jq -c '.costs.days[-1]' "$work/stats.json")"

# What build-stats.sh refuses: counts that aren't whole numbers, dates that
# don't exist or that Hugo can't read (year 1000), and a store with a link
# anywhere under stats; and it reads no other names.
for bad in '"x"' '1.5' '-1'; do
  b=$work/bad-count && rm -rf "$b" && mkdir -p "$b/stats/hourly"
  jq -n --argjson v "$bad" '{date: "2026-11-21", accounts: [range(24) | $v], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' >"$b/stats/hourly/2026-11-21.json"
  if "$root/scripts/build-stats.sh" "$b" "$work/bad.json" >/dev/null 2>&1; then fail "a count of $bad was accepted"; fi
done
b=$work/bad-date && mkdir -p "$b/stats/costs/production"
echo '{"month":"2026-11","days":{"2026-11-31":{"AWS Lambda":1}}}' >"$b/stats/costs/production/2026-11.json"
if "$root/scripts/build-stats.sh" "$b" "$work/bad.json" >/dev/null 2>&1; then fail "a day that doesn't exist was accepted"; fi
b=$work/bad-year && mkdir -p "$b/stats/hourly"
jq -n '{date: "1000-01-01", accounts: [range(24) | 1], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' >"$b/stats/hourly/1000-01-01.json"
if "$root/scripts/build-stats.sh" "$b" "$work/bad.json" >/dev/null 2>&1; then fail "year 1000 was accepted"; fi
# The newest day counted: the window ends an hour before end.
newest=$(date -u -d "$end - 1 hour" +%Y-%m-%d)
cp "$store/stats/hourly/$newest.json" "$work/real.json"
mkdir -p "$work/elsewhere/hourly"
cp "$work/real.json" "$work/elsewhere/hourly/"
for where in "stats/hourly/$newest.json" stats/hourly stats; do
  b=$work/bad-link && rm -rf "$b" && mkdir -p "$b/$(dirname "$where")"
  case $where in
    *.json) ln -s "$work/real.json" "$b/$where" ;;
    stats/hourly) ln -s "$work/elsewhere/hourly" "$b/$where" ;;
    stats) ln -s "$work/elsewhere" "$b/$where" ;;
  esac
  if "$root/scripts/build-stats.sh" "$b" "$work/link.json" >/dev/null 2>&1; then fail "a store with a link at $where was read"; fi
done
b=$work/bad-name && rm -rf "$b" && mkdir -p "$b/stats/hourly"
cp "$work/real.json" "$b/stats/hourly/x.json"
"$root/scripts/build-stats.sh" "$b" "$work/name.json" >/dev/null
[ "$(cat "$work/name.json")" = '{}' ] || fail "a file named other than yyyy-mm-dd.json was read"

# The site, with the numbers and with none.
build() { # stats.json output-dir messages-counted-from [media-counted-from]
  rm -rf "$work/site"
  cp -r "$root" "$work/site"
  rm -rf "$work/site/public" "$work/site/data/stats.json" "$work/site/.git" "$work/site/.stats-store"
  mkdir -p "$work/site/data"
  cp "$1" "$work/site/data/stats.json"
  sed -i "s/^    messages = \".*\"/    messages = \"$3\"/; s/^    media = \".*\"/    media = \"${4-$3}\"/" "$work/site/hugo.toml"
  hugo --quiet --source "$work/site" --destination "$2" >/dev/null
}
build "$work/stats.json" "$work/out" "2026-01-01T00"
page=$work/out/stats/index.html
grep -q '>5</p>' "$page" || fail "the accounts tile isn't 5"
grep -q '>7</p>' "$page" || fail "the messages tile isn't 7"
grep -q '2.0 MiB' "$page" || fail "the media tile isn't 2.0 MiB"
[ "$(grep -o 'class="bar"' "$page" | wc -l)" -ge 3 ] || fail "too few bars"
grep -q 'AWS WAF' "$page" || fail "no service in the legend"
grep -q '&lt;b&gt;AWS Lambda&lt;/b&gt;' "$page" || fail "a service name isn't escaped"
if grep -q '<b>AWS Lambda</b>' "$page"; then fail "a service name was written as HTML"; fi
grep -q 'class="seg so"' "$page" || fail "no Other segment"
grep -q 'Table view: by hour' "$page" || fail "no hourly table"
latest=$(jq -r .latest "$work/stats.json")
upto=$(date -u -d "${latest:0:10} ${latest:11:2}:00 + 1 hour" +'%Y-%m-%d %H:00 UTC')
grep -q "$upto" "$page" || fail "'Up to' isn't the end of the latest hour ($upto)"
grep -q '<h1>آمار</h1>' "$work/out/fa/stats/index.html" || fail "no Persian Stats page"

# Counted from an hour: earlier hours show as not counted, not as 0.
from=$(date -u -d "$end - 2 hours" +%Y-%m-%dT%H)
build "$work/stats.json" "$work/out1" "$from"
before=$(date -u -d "$end - 3 hours" +'%Y-%m-%d %H:00')
grep -q "$before UTC: —" "$work/out1/stats/index.html" || fail "an hour before counting started isn't shown as not counted"

# The hourly table too.
grep -qz "<td dir=\"ltr\">$before</td>\s*<td>0</td>\s*<td>—</td>\s*<td>—</td>" "$work/out1/stats/index.html" \
  || fail "the hourly table shows an hour before counting started as counted"

build "$work/stats.json" "$work/out2" ""
grep -q 'Counted from the next app release' "$work/out2/stats/index.html" || fail "messages shown before they're counted"

# A gap: the chart still covers the 7 days by the clock, the missing hours
# empty.
gap=$work/gap
mkdir -p "$gap/stats/hourly"
for day in 2026-11-01 2026-11-21; do
  jq -n --arg d "$day" '{date: $d, accounts: [range(24) | 1], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' \
    >"$gap/stats/hourly/$day.json"
done
"$root/scripts/build-stats.sh" "$gap" "$work/gap.json" >/dev/null
jq -e '(.hours | length) == 168 and .hours[0].t == "2026-11-15T00" and .hours[0].accounts == null and .hours[-1].t == "2026-11-21T23"' \
  "$work/gap.json" >/dev/null || fail "a gap isn't kept: $(jq -c '[.hours[0], .hours[-1]]' "$work/gap.json")"
# By day, messages counted from mid-day on the 21st, media from mid-day on
# the 1st: a day before either started shows "—" for it, and each first
# day, whole but only partly counted, is marked.
build "$work/gap.json" "$work/out5" "2026-11-21T05" "2026-11-01T05"
grep -qz '<td dir="ltr">2026-11-21 \*</td>\s*<td>24</td>\s*<td>0</td>\s*<td>0.0</td>' "$work/out5/stats/index.html" \
  || fail "the day messages started being counted isn't marked"
grep -qz '<td dir="ltr">2026-11-01 \*</td>\s*<td>24</td>\s*<td>—</td>\s*<td>0.0</td>' "$work/out5/stats/index.html" \
  || fail "the day media started being counted isn't marked, or messages before it are shown as counted"

# Costs only, from last month into this one: shown, with both months, and
# the test environment, never read, as a dash.
costs=$work/costs
mkdir -p "$costs/stats/costs/production"
echo '{"month":"2026-01","days":{"2026-01-31":{"AWS Lambda":2}}}' >"$costs/stats/costs/production/2026-01.json"
echo '{"month":"2026-02","days":{"2026-02-01":{"AWS Lambda":1}}}' >"$costs/stats/costs/production/2026-02.json"
# The test environment read only long before: not known for these months.
mkdir -p "$costs/stats/costs/dev"
echo '{"month":"2025-06","days":{"2025-06-01":0.5}}' >"$costs/stats/costs/dev/2025-06.json"
"$root/scripts/build-stats.sh" "$costs" "$work/costs.json" >/dev/null
jq -e '.costs.month == {name: "2026-02", production: 1, dev: null} and .costs.previous == {name: "2026-01", production: 2, dev: null} and all(.costs.days[]; .dev == null)' \
  "$work/costs.json" >/dev/null || fail "month totals: $(jq -c '[.costs.month, .costs.previous]' "$work/costs.json")"
# Read for last month only: this month's unknown, not $0.
costs2=$work/costs2
cp -r "$costs" "$costs2"
rm "$costs2"/stats/costs/dev/*
echo '{"month":"2026-01","days":{"2026-01-31":0.5}}' >"$costs2/stats/costs/dev/2026-01.json"
"$root/scripts/build-stats.sh" "$costs2" "$work/costs2.json" >/dev/null
jq -e '.costs.month.dev == null and .costs.previous.dev == 0.5 and [.costs.days[].dev] == [0.5, null]' "$work/costs2.json" >/dev/null \
  || fail "test-environment costs known for last month only: $(jq -c '[.costs.month, .costs.previous, [.costs.days[].dev]]' "$work/costs2.json")"
build "$work/costs.json" "$work/out4" "2026-01-01T00"
# shellcheck disable=SC2016 # a literal dollar sign
grep -qF '$1.00' "$work/out4/stats/index.html" || fail "costs alone aren't shown"
if grep -q 'No numbers yet' "$work/out4/stats/index.html"; then fail "costs alone are hidden"; fi
grep -q 'tile-value" dir="ltr">—' "$work/out4/stats/index.html" || fail "an unread test environment isn't a dash"
grep -q 'Last month, production' "$work/out4/stats/index.html" || fail "last month's tile says both"

echo '{}' >"$work/empty.json"
build "$work/empty.json" "$work/out3" ""
grep -q 'No numbers yet' "$work/out3/stats/index.html" || fail "an empty store isn't said so"

echo "ok: statistics pipeline"
