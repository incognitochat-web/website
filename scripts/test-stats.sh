#!/usr/bin/env bash
# Tests the statistics pipeline end to end, offline: collect-stats.sh
# against a stand-in AWS CLI with known answers, a second run that must
# change nothing, build-stats.sh, then Hugo, and checks what the Stats page
# shows; also the page with no numbers yet. Touches nothing but a temporary
# folder. Needs hugo and jq.
#
#   scripts/test-stats.sh
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

# The stand-in: CloudWatch-shaped hours relative to the window asked for,
# and Cost Explorer-shaped days.
mkdir -p "$work/bin"
cat >"$work/bin/aws" <<'EOF'
#!/usr/bin/env bash
args="$*"
start=$(sed -n 's/.*--start-time \([^ ]*\).*/\1/p' <<<"$args")
case $args in
  "cloudwatch get-metric-data"*)
    t1=$(date -u -d "$start + 3 hours" +%Y-%m-%dT%H:%M:%S+00:00)
    t2=$(date -u -d "$start + 47 hours" +%Y-%m-%dT%H:%M:%SZ)
    cat <<J
{"MetricDataResults":[
 {"Id":"accounts","StatusCode":"Complete","Timestamps":["$t1","$t2"],"Values":[2.0,5.0]},
 {"Id":"messages","StatusCode":"Complete","Timestamps":["$t2"],"Values":[7.0]},
 {"Id":"media_bytes","StatusCode":"Complete","Timestamps":["$t2"],"Values":[2113536.0]}]}
J
    ;;
  "ce get-cost-and-usage"*)
    d=$(date -u -d yesterday +%Y-%m-%d)
    if [[ $args == *SERVICE* ]]; then
      groups='[{"Keys":["AWS Lambda"],"Metrics":{"UnblendedCost":{"Amount":"0.25","Unit":"USD"}}},{"Keys":["AmazonCloudWatch"],"Metrics":{"UnblendedCost":{"Amount":"0.5","Unit":"USD"}}},{"Keys":["Amazon DynamoDB"],"Metrics":{"UnblendedCost":{"Amount":"0.125","Unit":"USD"}}},{"Keys":["AWS WAF"],"Metrics":{"UnblendedCost":{"Amount":"1","Unit":"USD"}}},{"Keys":["Amazon Simple Storage Service"],"Metrics":{"UnblendedCost":{"Amount":"0.0625","Unit":"USD"}}},{"Keys":["AWS Key Management Service"],"Metrics":{"UnblendedCost":{"Amount":"0.0625","Unit":"USD"}}}]'
      echo "{\"ResultsByTime\":[{\"TimePeriod\":{\"Start\":\"$d\"},\"Estimated\":true,\"Groups\":$groups}]}"
    else
      echo "{\"ResultsByTime\":[{\"TimePeriod\":{\"Start\":\"$d\"},\"Estimated\":true,\"Total\":{\"UnblendedCost\":{\"Amount\":\"0.03\",\"Unit\":\"USD\"}},\"Groups\":[]}]}"
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

# Known values land in the right hours, and a second run changes nothing.
end=$(date -u +%Y-%m-%dT%H:00:00Z)
start=$(date -u -d "$end - 48 hours" +%Y-%m-%dT%H:00:00Z)
h3=$(date -u -d "$start + 3 hours" +%Y-%m-%dT%H)
file=$store/stats/hourly/${h3:0:10}.json
[ "$(jq ".accounts[${h3:11:2} | tonumber]" "$file")" = 2 ] || fail "accounts not in the hour they were counted: $file"
cp -r "$store" "$work/before"
run counts "$store"
diff -r "$work/before" "$store" >/dev/null || fail "a second run changed the store"

"$root/scripts/build-stats.sh" "$store" "$work/stats.json" >/dev/null
jq -e '.last24.accounts == 5 and .last24.messages == 7 and .last24.media_bytes == 2113536' "$work/stats.json" >/dev/null \
  || fail "last 24 hours: $(jq -c .last24 "$work/stats.json")"
jq -e '.costs.services == ["AWS WAF", "AmazonCloudWatch", "AWS Lambda", "Amazon DynamoDB", "Other"]' "$work/stats.json" >/dev/null \
  || fail "services: $(jq -c .costs.services "$work/stats.json")"
jq -e '.costs.days[-1].values == [1, 0.5, 0.25, 0.125, 0.125] and .costs.days[-1].dev == 0.03' "$work/stats.json" >/dev/null \
  || fail "a day's costs: $(jq -c '.costs.days[-1]' "$work/stats.json")"

# The site, with the numbers and with none.
build() { # stats.json output-dir [messages-from]
  rm -rf "$work/site"
  cp -r "$root" "$work/site"
  rm -rf "$work/site/public" "$work/site/data/stats.json" "$work/site/.git"
  mkdir -p "$work/site/data"
  cp "$1" "$work/site/data/stats.json"
  HUGO_PARAMS_STATSCOUNTEDFROM_MESSAGES=${3:-} HUGO_PARAMS_STATSCOUNTEDFROM_MEDIA=${3:-} \
    hugo --quiet --source "$work/site" --destination "$2" >/dev/null
}
build "$work/stats.json" "$work/out" "2026-01-01"
page=$work/out/stats/index.html
grep -q '>5</p>' "$page" || fail "the accounts tile isn't 5"
grep -q '>7</p>' "$page" || fail "the messages tile isn't 7"
grep -q '2.0 MiB' "$page" || fail "the media tile isn't 2.0 MiB"
[ "$(grep -o 'class="bar"' "$page" | wc -l)" -ge 3 ] || fail "too few bars"
grep -q 'AWS WAF' "$page" || fail "no service in the legend"
grep -q 'class="seg so"' "$page" || fail "no Other segment"
grep -q 'لینک\|آمار' "$work/out/fa/stats/index.html" || fail "no Persian Stats page"

build "$work/stats.json" "$work/out2"
grep -q 'Counted from the next app release' "$work/out2/stats/index.html" || fail "messages shown before they're counted"

echo '{}' >"$work/empty.json"
build "$work/empty.json" "$work/out3"
grep -q 'No numbers yet' "$work/out3/stats/index.html" || fail "an empty store isn't said so"

echo "ok: statistics pipeline"
