#!/usr/bin/env bash
# Turns the data store (the `data` branch, checked out at <store>) into
# what the Stats page shows, data/stats.json: the 7 days of hours up to the
# latest one counted (an hour never counted shows as a gap), the
# last 30 days by day, the last 24 hours' totals, and the costs of the last
# 30 days, production's 4 biggest services by name and the rest as "Other",
# with this month's and last month's totals. Run by the deploy before Hugo.
#
#   scripts/build-stats.sh <store> <output.json>
#
# With no store, or nothing in it, it writes {} and the page says there are
# no numbers yet.
set -euo pipefail
export TZ=UTC

store=${1:?usage: $0 <store> <output.json>}
out=${2:?usage: $0 <store> <output.json>}
mkdir -p "$(dirname "$out")"

# Plain files only: find doesn't follow links, a linked folder included.
files() { find "$store/$1" -maxdepth 1 -type f -name '*.json' 2>/dev/null | sort; }
mapfile -t hourly < <(files stats/hourly)
mapfile -t production < <(files stats/costs/production)
mapfile -t dev < <(files stats/costs/dev)
if [ ${#hourly[@]} -eq 0 ] && [ ${#production[@]} -eq 0 ] && [ ${#dev[@]} -eq 0 ]; then
  echo '{}' >"$out"
  echo "no statistics in $store"
  exit 0
fi

# Only the newest files matter: 31 days of hours, 2 months of costs.
recent() { # count files...
  local n=$1
  shift
  [ $# -eq 0 ] || printf '%s\n' "$@" | sort | tail -n "$n"
}
mapfile -t hourly < <(recent 31 ${hourly[@]+"${hourly[@]}"})
mapfile -t production < <(recent 2 ${production[@]+"${production[@]}"})
mapfile -t dev < <(recent 2 ${dev[@]+"${dev[@]}"})

# Every file must have the shape collect-stats.sh writes: counts that are
# whole numbers or null, real dates, amounts that are numbers. Anything else
# stops here (the deploy then shows no numbers) instead of breaking the page.
jq -n -e \
  --slurpfile hourly <(cat /dev/null ${hourly[@]+"${hourly[@]}"}) \
  --slurpfile production <(cat /dev/null ${production[@]+"${production[@]}"}) \
  --slurpfile dev <(cat /dev/null ${dev[@]+"${dev[@]}"}) '
  def isdate: type == "string" and test("\\A[0-9]{4}-[0-9]{2}-[0-9]{2}\\z")
    and ((. + "T00:00:00Z" | try fromdateiso8601 catch null) as $t | $t != null and ($t | strftime("%Y-%m-%d")) == .);
  def counts: type == "array" and length == 24 and all(.[]; . == null or (type == "number" and . >= 0 and . == floor and . < 1e15));
  def amount: type == "number" and . > -1e9 and . < 1e9;
  def month($m): type == "object" and (.month | type == "string" and test("\\A[0-9]{4}-[0-9]{2}\\z")) and .month == $m
    and (.days | type == "object") and all(.days | keys[]; isdate and startswith($m));
  all($hourly[]; type == "object" and (.date | isdate) and (.accounts | counts) and (.messages | counts) and (.media_bytes | counts))
  and all($production[]; month(.month) and all(.days[]; type == "object" and all(to_entries[]; (.key | type == "string" and length <= 100) and (.value | amount))))
  and all($dev[]; month(.month) and all(.days[]; amount))
' >/dev/null || { echo "the statistics in $store don't have the expected shape" >&2; exit 1; }

jq -n -S \
  --slurpfile hourly <(cat /dev/null ${hourly[@]+"${hourly[@]}"}) \
  --slurpfile production <(cat /dev/null ${production[@]+"${production[@]}"}) \
  --slurpfile dev <(cat /dev/null ${dev[@]+"${dev[@]}"}) '
  def sum: map(select(. != null)) | add // 0;
  def round4: . * 10000 | round / 10000;

  def hourname: strftime("%Y-%m-%dT%H");
  # Every hour stored, oldest first: {t: "2026-11-21T07", accounts, messages, media_bytes}.
  ($hourly | sort_by(.date) | map(. as $d | range(24) as $h | {
    t: ($d.date + "T" + (if $h < 10 then "0" else "" end) + ($h | tostring)),
    accounts: $d.accounts[$h], messages: $d.messages[$h], media_bytes: $d.media_bytes[$h]
  })) as $all
  | ($all | map(select(.accounts != null))) as $known
  | ($all | map({key: .t, value: .}) | from_entries) as $byhour
  # The 168 hours up to the latest counted, by the clock: an hour never
  # counted is a gap (null), not left out.
  | (if ($known | length) == 0 then [] else
      ($known[-1].t + ":00:00Z" | fromdateiso8601) as $last
      | [range(167; -1; -1) as $i | ($last - $i * 3600 | hourname) as $t
         | ($byhour[$t] // {t: $t, accounts: null, messages: null, media_bytes: null})]
    end) as $hours
  | ($hours[-24:]) as $day

  # Costs by day: production by service, dev as one total.
  | ($production | map(.days) | add // {}) as $prod
  | ($dev | map(.days) | add // {}) as $devdays
  | ($prod | keys | sort | .[-30:]) as $costdays
  | ([$costdays[] as $d | $prod[$d] | to_entries[]] | group_by(.key)
      | map({key: .[0].key, value: (map(.value) | add)}) | sort_by(-.value) | map(.key)) as $ranked
  | ($ranked[:4]) as $named
  | ($costdays | map(. as $d | ($prod[$d] // {}) as $s | {
      date: $d,
      values: ([$named[] as $n | ($s[$n] // 0)] + [([$s | to_entries[] | select(.key as $k | $named | index($k) | not) | .value] | add // 0)] | map(round4)),
      total: ([$s[]] | add // 0 | round4),
      dev: (($devdays[$d] // 0) | round4)
    })) as $costs
  | ($costdays[-1] // "" | .[0:7]) as $month
  | (if $month == "" then "" else ($month + "-01" | strptime("%Y-%m-%d") | mktime - 86400 | strftime("%Y-%m")) end) as $previous
  | def month_total($days; $m): [$days | to_entries[] | select(.key | startswith($m)) | .value | if type == "object" then ([.[]] | add // 0) else . end] | add // 0 | round4;

  {
    latest: ($known[-1].t // null),
    dev_known: (($dev | length) > 0),
    hours: $hours,
    last24: {accounts: ($day | map(.accounts) | sum), messages: ($day | map(.messages) | sum), media_bytes: ($day | map(.media_bytes) | sum)},
    days: ($all | group_by(.t[0:10]) | map({date: .[0].t[0:10], hours: (map(select(.accounts != null)) | length),
      accounts: (map(.accounts) | sum), messages: (map(.messages) | sum), media_bytes: (map(.media_bytes) | sum)})
      | map(select(.hours > 0)) | .[-30:]),
    costs: {
      services: ($named + (if ($ranked | length) > 4 then ["Other"] else [] end)),
      days: ($costs | if ($ranked | length) > 4 then . else map(.values |= .[0:-1]) end),
      month: {name: $month, production: month_total($prod; $month), dev: month_total($devdays; $month)},
      previous: {name: $previous, production: month_total($prod; $previous), dev: month_total($devdays; $previous)}
    }
  }' >"$out"
echo "statistics: $(jq -r '"\(.hours | length) hours, \(.days | length) days, \(.costs.days | length) days of costs, latest \(.latest)"' "$out")"
