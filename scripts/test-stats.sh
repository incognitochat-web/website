#!/usr/bin/env bash
# Tests the statistics pipeline end to end, offline: collect-stats.sh
# against a stand-in AWS CLI with known answers (and its refusals), a second
# run that must change nothing, build-stats.sh (and what it refuses), then
# Hugo, and checks what the Stats and Costs pages show, with numbers, with costs only,
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
# Yesterday's costs, in its month: that month's biggest four, then Other.
ym=${yesterday:0:7}
jq -e --arg m "$ym" '.months[] | select(.month == $m) | .services == ["AWS WAF", "AmazonCloudWatch", "<b>AWS Lambda</b>", "Amazon DynamoDB", "Other"]' "$work/stats.json" >/dev/null \
  || fail "services: $(jq -c --arg m "$ym" '.months[] | select(.month == $m) | .services' "$work/stats.json")"
jq -e --arg m "$ym" --arg y "$yesterday" '.months[] | select(.month == $m) | .days[] | select(.date == $y) | .values == [1, 0.5, 0.25, 0.125, 0.125] and .total == 2 and .dev == 0.03' "$work/stats.json" >/dev/null \
  || fail "a day's costs: $(jq -c --arg m "$ym" --arg y "$yesterday" '.months[] | select(.month == $m) | .days[] | select(.date == $y)' "$work/stats.json")"

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
build() { # stats.json output-dir messages-counted-from [media-counted-from] [accounts-counted-from]
  rm -rf "$work/site"
  cp -r "$root" "$work/site"
  rm -rf "$work/site/public" "$work/site/data/stats.json" "$work/site/.git" "$work/site/.stats-store"
  mkdir -p "$work/site/data"
  cp "$1" "$work/site/data/stats.json"
  sed -i "s/^    messages = \".*\"/    messages = \"$3\"/; s/^    media = \".*\"/    media = \"${4-$3}\"/; s/^    accounts = \".*\"/    accounts = \"${5-2000-01-01T00}\"/" "$work/site/hugo.toml"
  hugo --quiet --source "$work/site" --destination "$2" >/dev/null
}
build "$work/stats.json" "$work/out" "2026-01-01T00"
page=$work/out/stats/index.html
grep -q '>5</p>' "$page" || fail "the accounts tile isn't 5"
grep -q '>7</p>' "$page" || fail "the messages tile isn't 7"
grep -q '2.0 MiB' "$page" || fail "the media tile isn't 2.0 MiB"
[ "$(grep -o 'class="bar"' "$page" | wc -l)" -ge 3 ] || fail "too few bars"
# The costs are on their own page; Stats links to it.
cpage=$work/out/costs/index.html
grep -q 'AWS WAF' "$cpage" || fail "no service in the legend"
grep -q '&lt;b&gt;AWS Lambda&lt;/b&gt;' "$cpage" || fail "a service name isn't escaped"
if grep -q '<b>AWS Lambda</b>' "$cpage"; then fail "a service name was written as HTML"; fi
if grep -q 'legend-amount\|AWS WAF\|tile-name">Production\|tile-name">Test environment' "$page"; then fail "costs on the Stats page"; fi
grep -q 'class="stats-more">What running the service costs: <a href="/costs/">Costs</a>' "$page" || fail "the Stats page doesn't link to Costs"
# Costs links Donate only once Donate is published (a draft has no page).
if grep -q '^draft: true' "$root/content/donate.md"; then
  if grep -q 'href="/donate/"' "$cpage"; then fail "Costs links the unpublished Donate page"; fi
else
  grep -q 'href="/donate/"' "$cpage" || fail "Costs doesn't link the published Donate page"
fi
hugo --quiet --buildDrafts --source "$work/site" --destination "$work/out-drafts" >/dev/null
grep -q 'class="stats-more">Donations help pay these costs: <a href="/donate/">Donate</a>' "$work/out-drafts/costs/index.html" \
  || fail "Costs doesn't link Donate once it's published"
grep -q 'class="seg so"' "$cpage" || fail "no Other segment"
grep -q 'Table: day by day' "$page" || fail "no day-by-day table"
grep -q "class=\"month newest\" id=\"m-$(jq -r '.months[0].month' "$work/stats.json")\"" "$page" || fail "the newest month isn't the one shown"
latest=$(jq -r .latest "$work/stats.json")
upto=$(date -u -d "${latest:0:10} ${latest:11:2}:00 + 1 hour" +'%Y-%m-%d %H:00 UTC')
grep -q "$upto" "$page" || fail "'Up to' isn't the end of the latest hour ($upto)"
grep -q '<h1>آمار</h1>' "$work/out/fa/stats/index.html" || fail "no Persian Stats page"
grep -q '<h1>Статистика</h1>' "$work/out/ru/stats/index.html" || fail "no Russian Stats page"
grep -q '<h1>الإحصاءات</h1>' "$work/out/ar/stats/index.html" || fail "no Arabic Stats page"
grep -q '<h1>Statistieken</h1>' "$work/out/nl/stats/index.html" || fail "no Dutch Stats page"
grep -q '<h1>Estadísticas</h1>' "$work/out/es/stats/index.html" || fail "no Spanish Stats page"
grep -q '<h1>Estatísticas</h1>' "$work/out/pt-br/stats/index.html" || fail "no Brazilian Portuguese Stats page"
grep -q '<h1>Statistik</h1>' "$work/out/id/stats/index.html" || fail "no Indonesian Stats page"
grep -q '<h1>İstatistikler</h1>' "$work/out/tr/stats/index.html" || fail "no Turkish Stats page"
grep -q '<h1>Статистика</h1>' "$work/out/uk/stats/index.html" || fail "no Ukrainian Stats page"
grep -q '<h1>Statistiques</h1>' "$work/out/fr/stats/index.html" || fail "no French Stats page"
grep -q '<h1>Statistik</h1>' "$work/out/de/stats/index.html" || fail "no German Stats page"

# Numbers are written the page's language's way: a decimal point in English,
# a comma in Dutch (and Russian, Spanish, Portuguese, Indonesian, Turkish).
en_costs=$(cat "$cpage") nl_costs=$(cat "$work/out/nl/costs/index.html") nl_stats=$(cat "$work/out/nl/stats/index.html")
[[ $en_costs == *'>$2.00</p>'* ]] || fail "English costs aren't written as \$2.00"
[[ $nl_costs == *'>$2,00</p>'* ]] || fail "Dutch costs aren't written as \$2,00"
[[ $nl_stats == *'2,0 MiB'* ]] || fail "Dutch media isn't written as 2,0 MiB"
# Nowhere left with a decimal point: tiles, tables, chart tooltips, captions, legends.
dot_money='\$[0-9]+\.[0-9]' dot_mib='[0-9]\.[0-9] MiB' dot_cell='<td>[0-9]+\.[0-9]</td>'
if [[ $nl_costs =~ $dot_money ]]; then fail "a Dutch cost is written with a decimal point: ${BASH_REMATCH[0]}"; fi
if [[ $nl_stats =~ $dot_mib || $nl_stats =~ $dot_cell ]]; then fail "a Dutch media size is written with a decimal point: ${BASH_REMATCH[0]}"; fi
# And thousands are grouped: 1,234.50 in English, 1 234,50 in Russian.
jq '.months[0].totals.production = 1234.5' "$work/stats.json" >"$work/big.json"
build "$work/big.json" "$work/out-big" "2026-01-01T00"
en_big=$(cat "$work/out-big/costs/index.html") ru_big=$(cat "$work/out-big/ru/costs/index.html")
[[ $en_big == *'>$1,234.50</p>'* ]] || fail "English thousands aren't written as \$1,234.50"
[[ $ru_big == *$'>$1\u00a0234,50</p>'* ]] || fail "Russian thousands aren't written as \$1 234,50, with a no-break space"

# Counted from an hour: earlier hours show as not counted, not as 0.
from=$(date -u -d "$end - 2 hours" +%Y-%m-%dT%H)
build "$work/stats.json" "$work/out1" "$from"
before=$(date -u -d "$end - 3 hours" +'%Y-%m-%d %H:00')
grep -q "$before UTC: —" "$work/out1/stats/index.html" || fail "an hour before counting started isn't shown as not counted"


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
# A day of the month before, for a second month with counts.
jq -n '{date: "2026-10-31", accounts: [range(24) | 1], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' \
  >"$gap/stats/hourly/2026-10-31.json"
# A day stored but never counted (every hour null): not counted, not 0.
jq -n '{date: "2026-11-10", accounts: [range(24) | null], messages: [range(24) | null], media_bytes: [range(24) | null]}' \
  >"$gap/stats/hourly/2026-11-10.json"
"$root/scripts/build-stats.sh" "$gap" "$work/gap.json" >/dev/null
jq -e '(.hours | length) == 168 and .hours[0].t == "2026-11-15T00" and .hours[0].accounts == null and .hours[-1].t == "2026-11-21T23"' \
  "$work/gap.json" >/dev/null || fail "a gap isn't kept: $(jq -c '[.hours[0], .hours[-1]]' "$work/gap.json")"
# By month: every day up to the last one counted, uncounted days null.
jq -e '(.months | length) == 2 and .months[0].month == "2026-11" and .months[1].month == "2026-10" and (.months[0].days | length) == 21
  and .months[0].days[1].accounts == null and .months[0].days[9].accounts == null and .months[0].totals.accounts == 48 and .months[0].totals.production == null' \
  "$work/gap.json" >/dev/null || fail "a month's days: $(jq -c '.months[0] | {month, n: (.days | length), totals}' "$work/gap.json")"
# By day, messages counted from mid-day on the 21st, media from mid-day on
# the 1st: a day before either started shows "—" for it, and each first
# day, whole but only partly counted, is marked.
build "$work/gap.json" "$work/out5" "2026-11-21T05" "2026-11-01T05"
grep -qz '<td dir="ltr">2026-11-21 \*</td>\s*<td>24</td>\s*<td>0</td>\s*<td>0.0</td>' "$work/out5/stats/index.html" \
  || fail "the day messages started being counted isn't marked"
grep -qz '<td dir="ltr">2026-11-01 \*</td>\s*<td>24</td>\s*<td>—</td>\s*<td>0.0</td>' "$work/out5/stats/index.html" \
  || fail "the day media started being counted isn't marked, or messages before it are shown as counted"
# The month's totals say from when each was counted.
grep -q 'Messages sent: counted from 21 November, <span dir="ltr">05:00 UTC</span>' "$work/out5/stats/index.html" || fail "no note on when messages started being counted"
grep -q 'Media: counted from 1 November, <span dir="ltr">05:00 UTC</span>' "$work/out5/stats/index.html" || fail "no note on when media started being counted"
# Ukrainian month headings are nominative, unlike after a day.
grep -q '<h2>Листопад 2026</h2>' "$work/out5/uk/stats/index.html" || fail "Ukrainian month headings aren't nominative"
grep -q 'з 1 листопада, <span dir="ltr">05:00 UTC</span>' "$work/out5/uk/stats/index.html" || fail "a Ukrainian day isn't followed by its month in the genitive"
grep -q '>48</p>' "$work/out5/stats/index.html" || fail "the month's accounts tile isn't 48"
# Counts alone: Costs has no months.
grep -q 'No costs yet' "$work/out5/costs/index.html" || fail "months with counts alone are on the Costs page"
# A day before counting started is "—" in its chart too.
grep -q '<title>2026-11-01: —</title>' "$work/out5/stats/index.html" || fail "a day before counting started is charted as counted"
# The hourly charts only in the newest month; every month has the links, its own marked.
[ "$(grep -c 'Hour by hour, the last 7 days' "$work/out5/stats/index.html")" = 1 ] || fail "the hourly charts aren't only in the newest month"
grep -q 'href="#m-2026-10" aria-current="true"' "$work/out5/stats/index.html" || fail "October's links don't mark October"
nov=$(sed -n '/id="m-2026-11"/,/<\/section>/p' "$work/out5/stats/index.html")
[ "$(grep -o 'aria-current="true"' <<<"$nov" | wc -l)" = 1 ] || fail "November's links mark more than one month"
grep -q 'href="#m-2026-11" aria-current="true"' <<<"$nov" || fail "November's links don't mark November"
# The hourly chart's dates are short, to fit on a phone.
grep -q '>16 Nov</text>' "$work/out5/stats/index.html" || fail "the hourly chart's dates aren't short"
# Counting that starts at a month's first hour counts the whole month: no "*".
build "$work/gap.json" "$work/out7" "2026-11-21T05" "2026-11-21T05" "2026-11-01T00"
grep -q '>48</p>' "$work/out7/stats/index.html" || fail "a start at the month's first hour marks the month as partly counted"
# Two metrics that start together share one note.
[ "$(grep -o 'Messages sent, Media: counted from 21 November' "$work/out7/stats/index.html" | wc -l)" = 1 ] || fail "metrics starting together don't share one note"
# Accounts counted only from a later month: this month shows "—" for them.
build "$work/gap.json" "$work/out6" "2026-11-21T05" "2026-11-01T05" "2026-12-01T00"
if grep -q '>48</p>' "$work/out6/stats/index.html"; then fail "accounts shown for a month before they were counted"; fi

# Costs only, from last month into this one: shown, with both months, and
# the test environment, never read, as a dash.
costs=$work/costs
mkdir -p "$costs/stats/costs/production"
echo '{"month":"2026-01","days":{"2026-01-31":{"AWS Lambda":2}}}' >"$costs/stats/costs/production/2026-01.json"
echo '{"month":"2026-02","days":{"2026-02-01":{"AWS Lambda":1}}}' >"$costs/stats/costs/production/2026-02.json"
# A month read, costing nothing: $0.00, not "—".
echo '{"month":"2025-12","days":{"2025-12-01":{}}}' >"$costs/stats/costs/production/2025-12.json"
# The test environment read only long before: not known for these months.
mkdir -p "$costs/stats/costs/dev"
echo '{"month":"2025-06","days":{"2025-06-01":0.5}}' >"$costs/stats/costs/dev/2025-06.json"
"$root/scripts/build-stats.sh" "$costs" "$work/costs.json" >/dev/null
jq -e '[.months[].month] == ["2026-02", "2026-01", "2025-12", "2025-06"]
  and .months[0].totals.production == 1 and .months[0].totals.dev == null
  and .months[1].totals.production == 2 and .months[1].totals.dev == null
  and .months[2].totals.production == 0
  and .months[3].totals.production == null and .months[3].totals.dev == 0.5
  and all(.months[0, 1].days[]; .dev == null)' \
  "$work/costs.json" >/dev/null || fail "month totals: $(jq -c '[.months[] | {month, totals}]' "$work/costs.json")"
# Read for last month only: this month's unknown, not $0.
costs2=$work/costs2
cp -r "$costs" "$costs2"
rm "$costs2"/stats/costs/dev/*
echo '{"month":"2026-01","days":{"2026-01-31":0.5}}' >"$costs2/stats/costs/dev/2026-01.json"
"$root/scripts/build-stats.sh" "$costs2" "$work/costs2.json" >/dev/null
jq -e '.months[0].totals.dev == null and .months[1].totals.dev == 0.5 and .months[1].days[-1].dev == 0.5 and .months[0].days[0].dev == null' "$work/costs2.json" >/dev/null \
  || fail "test-environment costs known for last month only: $(jq -c '[.months[] | {month, totals}]' "$work/costs2.json")"
# Read this month, but not for its latest day (its run failed): that day is unknown, not $0.
costs3=$work/costs3
cp -r "$costs" "$costs3"
rm "$costs3"/stats/costs/dev/*
echo '{"month":"2026-01","days":{"2026-01-31":0}}' >"$costs3/stats/costs/dev/2026-01.json"
echo '{"month":"2026-02","days":{}}' >"$costs3/stats/costs/dev/2026-02.json"
"$root/scripts/build-stats.sh" "$costs3" "$work/costs3.json" >/dev/null
jq -e '.months[1].days[-1].dev == 0 and .months[0].days[0].dev == null and .months[0].totals.dev == null' "$work/costs3.json" >/dev/null \
  || fail "a day the test environment wasn't read for: $(jq -c '[.months[1].days[-1].dev, .months[0].days[0].dev]' "$work/costs3.json")"
build "$work/costs.json" "$work/out4" "2026-01-01T00"
# Costs alone: Stats has no months, Costs has them all.
grep -q 'No numbers yet' "$work/out4/stats/index.html" || fail "months with costs alone are on the Stats page"
# shellcheck disable=SC2016 # a literal dollar sign
grep -qF '$1.00' "$work/out4/costs/index.html" || fail "costs alone aren't shown"
grep -q 'tile-value" dir="ltr">—' "$work/out4/costs/index.html" || fail "an unread test environment isn't a dash"
grep -q 'href="#c-2026-01"' "$work/out4/costs/index.html" || fail "no link to an earlier month"
# (The section is read first: grep -q in a pipe can stop sed early, and pipefail would fail.)
dec=$(sed -n '/id="c-2025-12"/,/<\/section>/p' "$work/out4/costs/index.html")
# shellcheck disable=SC2016 # literal dollar signs
grep -qF '>$0.00</p><p class="tile-name">Production' <<<"$dec" || fail "a month that cost nothing does not show \$0.00"
# shellcheck disable=SC2016 # a literal dollar sign
grep -qF 'legend-amount">$1.00<' "$work/out4/costs/index.html" || fail "the legend does not give a service's month total"
grep -q 'class="month newest" id="c-2026-02"' "$work/out4/costs/index.html" || fail "the newest month isn't shown first"
grep -q 'datetime="2026-02-01"' "$work/out4/costs/index.html" || fail "Costs isn't 'up to' the newest day production's costs were read"
# A month with the test environment's costs only is on Costs, production "—".
dev6=$(sed -n '/id="c-2025-06"/,/<\/section>/p' "$work/out4/costs/index.html")
grep -qF 'tile-value" dir="ltr">—</p><p class="tile-name">Production' <<<"$dev6" || fail "a month with test-environment costs only isn't on Costs"

# Counts in one month, costs in another: each page lists only its own.
mixed=$work/mixed
mkdir -p "$mixed/stats/hourly" "$mixed/stats/costs/production"
jq -n '{date: "2026-11-01", accounts: [range(24) | 1], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' >"$mixed/stats/hourly/2026-11-01.json"
echo '{"month":"2026-10","days":{"2026-10-31":{"AWS Lambda":1}}}' >"$mixed/stats/costs/production/2026-10.json"
"$root/scripts/build-stats.sh" "$mixed" "$work/mixed.json" >/dev/null
build "$work/mixed.json" "$work/out10" "2026-01-01T00"
grep -q 'id="m-2026-11"' "$work/out10/stats/index.html" || fail "a month with counts isn't on Stats"
if grep -q 'id="m-2026-10"' "$work/out10/stats/index.html"; then fail "a month with costs alone is on Stats"; fi
grep -q 'id="c-2026-10"' "$work/out10/costs/index.html" || fail "a month with costs isn't on Costs"
if grep -q 'id="c-2026-11"' "$work/out10/costs/index.html"; then fail "a month with counts alone is on Costs"; fi

# A month with six services: the four biggest by name, the rest as Other,
# each with its month total in the legend, in that order.
svc=$work/svc
mkdir -p "$svc/stats/costs/production"
echo '{"month":"2026-04","days":{"2026-04-01":{"A":5,"B":4,"C":3,"D":2,"E":1,"F":0.5},"2026-04-02":{"A":1,"E":0.5}}}' \
  >"$svc/stats/costs/production/2026-04.json"
"$root/scripts/build-stats.sh" "$svc" "$work/svc.json" >/dev/null
jq -e '.months[0].services == ["A", "B", "C", "D", "Other"] and .months[0].service_totals == [6, 4, 3, 2, 2] and .months[0].totals.production == 17' \
  "$work/svc.json" >/dev/null || fail "services and their totals: $(jq -c '.months[0] | {services, service_totals}' "$work/svc.json")"
build "$work/svc.json" "$work/out8" "2026-01-01T00"
# A service that cost nothing that month shows $0.00, not nothing.
zero=$work/zero
mkdir -p "$zero/stats/costs/production"
echo '{"month":"2026-04","days":{"2026-04-01":{"A":1,"B":0}}}' >"$zero/stats/costs/production/2026-04.json"
"$root/scripts/build-stats.sh" "$zero" "$work/zero.json" >/dev/null
build "$work/zero.json" "$work/out9" "2026-01-01T00"
# shellcheck disable=SC2016 # a literal dollar sign
grep -qF '</span>B <span class="legend-amount">$0.00<' "$work/out9/costs/index.html" || fail "a service that cost nothing has no \$0.00 in the legend"
legend=$(grep -o '</span>[A-Za-z]* <span class="legend-amount">[^<]*' "$work/out8/costs/index.html" | sed 's/<[^>]*>//g' | tr '\n' ',')
# shellcheck disable=SC2016 # literal dollar signs
[ "$legend" = 'A $6.00,B $4.00,C $3.00,D $2.00,Other $2.00,' ] || fail "the legend's services and totals: $legend"

# Only the newest 13 months are shown.
many=$work/many
mkdir -p "$many/stats/costs/production"
mkdir -p "$many/stats/hourly"
for m in 2025-01 2025-02 2025-03 2025-04 2025-05 2025-06 2025-07 2025-08 2025-09 2025-10 2025-11 2025-12 2026-01 2026-02 2026-03; do
  echo "{\"month\":\"$m\",\"days\":{\"$m-01\":{\"AWS Lambda\":1}}}" >"$many/stats/costs/production/$m.json"
done
# Hours in the two oldest months too: also left out.
for d in 2025-01-15 2025-02-15 2026-03-01; do
  jq -n --arg d "$d" '{date: $d, accounts: [range(24) | 1], messages: [range(24) | 0], media_bytes: [range(24) | 0]}' >"$many/stats/hourly/$d.json"
done
"$root/scripts/build-stats.sh" "$many" "$work/many.json" >/dev/null
jq -e '(.months | length) == 13 and .months[0].month == "2026-03" and .months[-1].month == "2025-03"' "$work/many.json" >/dev/null \
  || fail "not the newest 13 months: $(jq -c '[.months[].month]' "$work/many.json")"

echo '{}' >"$work/empty.json"
build "$work/empty.json" "$work/out3" ""
grep -q 'No numbers yet' "$work/out3/stats/index.html" || fail "an empty store isn't said so"
grep -q 'No costs yet' "$work/out3/costs/index.html" || fail "an empty store isn't said so on Costs"

echo "ok: statistics pipeline"
