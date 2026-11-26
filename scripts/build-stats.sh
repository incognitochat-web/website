#!/usr/bin/env bash
# Turns the data store (the `data` branch, checked out at <store>) into
# what the Stats and Costs pages show, data/stats.json:
# - months: the newest 13 months, newest first, each with its days (counts,
#   production's costs by service, the test environment's total) and its
#   totals; production's 4 biggest services that month by name, the rest
#   as "Other". A day or month not counted (or a cost not read) is null.
# - the 7 days of hours up to the latest one counted (an hour never counted
#   is a gap) and the last 24 hours' totals, for the newest month.
# Run by the deploy before Hugo.
#
#   scripts/build-stats.sh <store> <output.json>
#
# With no store, or nothing in it, it writes {} and the page says there are
# no numbers yet.
set -euo pipefail
export TZ=UTC
# [0-9] means ASCII digits only, whatever the machine's language.
export LC_ALL=C

store=${1:?usage: $0 <store> <output.json>}
out=${2:?usage: $0 <store> <output.json>}
mkdir -p "$(dirname "$out")"

# Plain files only. A link anywhere under stats (stats itself included)
# could lead outside the store, so the store is refused, and only names
# collect-stats.sh writes are read (yyyy-mm-dd.json, yyyy-mm.json, and
# yyyy-mm-from-dd.json for a month whose costs were read again only from a
# day on): nothing with a newline or a path in it.
if [ -e "$store/stats" ] || [ -L "$store/stats" ]; then
  # Assigned first, so a find that fails stops here (set -e).
  links=$(find "$store/stats" -type l -print -quit)
  if [ -L "$store/stats" ] || [ -n "$links" ]; then
    echo "$store/stats has a link in it; not read" >&2
    exit 1
  fi
fi
day='[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].json'
month='[0-9][0-9][0-9][0-9]-[0-9][0-9].json'
cut='[0-9][0-9][0-9][0-9]-[0-9][0-9]-from-[0-9][0-9].json'
files() { find "$store/$1" -maxdepth 1 -type f -name "$2" 2>/dev/null | sort; }
mapfile -t hourly < <(files stats/hourly "$day")
mapfile -t production < <(files stats/costs/production "$month")
mapfile -t dev < <(files stats/costs/dev "$month")
mapfile -t production_cut < <(files stats/costs/production "$cut")
mapfile -t dev_cut < <(files stats/costs/dev "$cut")
if [ ${#hourly[@]} -eq 0 ] && [ ${#production[@]} -eq 0 ] && [ ${#dev[@]} -eq 0 ] \
  && [ ${#production_cut[@]} -eq 0 ] && [ ${#dev_cut[@]} -eq 0 ]; then
  echo '{}' >"$out"
  echo "no statistics in $store"
  exit 0
fi

# Only the newest 13 months are shown: this one and the 12 before it.
mapfile -t shown < <(for f in ${hourly[@]+"${hourly[@]}"} ${production[@]+"${production[@]}"} ${dev[@]+"${dev[@]}"} \
  ${production_cut[@]+"${production_cut[@]}"} ${dev_cut[@]+"${dev_cut[@]}"}; do
  b=$(basename "$f"); echo "${b:0:7}"; done | sort -u | tail -n 13)
within() { # files... -> those of a shown month
  local f b m
  for f in "$@"; do
    b=$(basename "$f")
    for m in "${shown[@]}"; do [ "${b:0:7}" = "$m" ] && echo "$f"; done
  done
}
mapfile -t hourly < <(within ${hourly[@]+"${hourly[@]}"})
mapfile -t production < <(within ${production[@]+"${production[@]}"})
mapfile -t dev < <(within ${dev[@]+"${dev[@]}"})
mapfile -t production_cut < <(within ${production_cut[@]+"${production_cut[@]}"})
mapfile -t dev_cut < <(within ${dev_cut[@]+"${dev_cut[@]}"})

# A month's -from- file must say what its name says (the month, and the day
# it was read from), with no day before that one.
for f in ${production_cut[@]+"${production_cut[@]}"} ${dev_cut[@]+"${dev_cut[@]}"}; do
  b=$(basename "$f" .json)
  jq -e --arg m "${b:0:7}" --arg from "${b:0:7}-${b:13:2}" \
    'type == "object" and .month == $m and .from == $from and (.days | type == "object") and all(.days | keys[]; . >= $from)' \
    "$f" >/dev/null 2>&1 || { echo "$f doesn't hold what its name says; not read" >&2; exit 1; }
done

# Every file must have the shape collect-stats.sh writes: counts that are
# whole numbers or null, real dates, amounts that are numbers. Anything else
# stops here (the deploy then shows no numbers) instead of breaking the page.
jq -n -e \
  --slurpfile hourly <(cat /dev/null ${hourly[@]+"${hourly[@]}"}) \
  --slurpfile production <(cat /dev/null ${production[@]+"${production[@]}"} ${production_cut[@]+"${production_cut[@]}"}) \
  --slurpfile dev <(cat /dev/null ${dev[@]+"${dev[@]}"} ${dev_cut[@]+"${dev_cut[@]}"}) \
  --slurpfile production_cut <(cat /dev/null ${production_cut[@]+"${production_cut[@]}"}) \
  --slurpfile dev_cut <(cat /dev/null ${dev_cut[@]+"${dev_cut[@]}"}) '
  # Years 2000 to 2099: a week before year 1000 has a 3-digit year, which
  # Hugo cannot read.
  def isdate: type == "string" and test("\\A20[0-9]{2}-[0-9]{2}-[0-9]{2}\\z")
    and ((. + "T00:00:00Z" | try fromdateiso8601 catch null) as $t | $t != null and ($t | strftime("%Y-%m-%d")) == .);
  def counts: type == "array" and length == 24 and all(.[]; . == null or (type == "number" and . >= 0 and . == floor and . < 1e15));
  def amount: type == "number" and . > -1e9 and . < 1e9;
  def month($m): type == "object" and (.month | type == "string" and test("\\A20[0-9]{2}-(0[1-9]|1[0-2])\\z")) and .month == $m
    and (.days | type == "object") and all(.days | keys[]; isdate and startswith($m));
  all($hourly[]; type == "object" and (.date | isdate) and (.accounts | counts) and (.messages | counts) and (.media_bytes | counts))
  and all($production[]; month(.month) and all(.days[]; type == "object" and all(to_entries[]; (.key | type == "string" and length <= 100) and (.value | amount))))
  and all($dev[]; month(.month) and all(.days[]; amount))
  # A -from- file: a real day, and only one for a month.
  and all($production_cut[], $dev_cut[]; .from | isdate)
  and ($production_cut | map(.month) | length == (unique | length))
  and ($dev_cut | map(.month) | length == (unique | length))
' >/dev/null || { echo "the statistics in $store don't have the expected shape" >&2; exit 1; }

jq -n -S \
  --slurpfile hourly <(cat /dev/null ${hourly[@]+"${hourly[@]}"}) \
  --slurpfile production <(cat /dev/null ${production[@]+"${production[@]}"}) \
  --slurpfile dev <(cat /dev/null ${dev[@]+"${dev[@]}"}) \
  --slurpfile production_cut <(cat /dev/null ${production_cut[@]+"${production_cut[@]}"}) \
  --slurpfile dev_cut <(cat /dev/null ${dev_cut[@]+"${dev_cut[@]}"}) '
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

  # Each day stored: the hours counted and their sums.
  | ($all | group_by(.t[0:10]) | map({key: .[0].t[0:10], value: {
      hours: (map(select(.accounts != null)) | length),
      accounts: (map(.accounts) | sum), messages: (map(.messages) | sum), media_bytes: (map(.media_bytes) | sum)
    }}) | from_entries) as $counted
  # Costs by day: production by service, dev as one total. A day missing
  # from a file was not read. A month with a -from- file: the month file
  # until the day it names, the -from- file from that day on.
  | def joined($files; $cuts): ($cuts | map({key: .month, value: .from}) | from_entries) as $cut
      | ($files | map(.days) | add // {} | with_entries(select($cut[.key[0:7]] as $c | $c == null or .key < $c)))
        + ($cuts | map(.days) | add // {});
  joined($production; $production_cut) as $prod
  | joined($dev; $dev_cut) as $devdays
  # The last day anything was counted or read; a month shows its days up to it.
  | ([($known[-1].t // "" | .[0:10]), ($prod | keys | max // ""), ($devdays | keys | max // "")] | max) as $lastday
  | (([$all[].t[0:7]] + [$prod | keys[] | .[0:7]] + [$devdays | keys[] | .[0:7]]) | unique | reverse) as $months
  | def known(f): [.[] | f | select(. != null)] | if length > 0 then add | round4 else null end;

  {
    latest: ($known[-1].t // null),
    hours: $hours,
    last24: {accounts: ($day | map(.accounts) | sum), messages: ($day | map(.messages) | sum), media_bytes: ($day | map(.media_bytes) | sum)},
    months: [$months[] as $m
      | ($m + "-01T00:00:00Z" | fromdateiso8601) as $first
      | [range(0; 31) as $n | ($first + $n * 86400 | strftime("%Y-%m-%d")) | select(startswith($m) and . <= $lastday)] as $dates
      | ([$dates[] as $d | ($prod[$d] // {}) | to_entries[]] | group_by(.key)
          | map({key: .[0].key, value: (map(.value) | add)}) | sort_by(-.value) | map(.key)) as $ranked
      | ($ranked[:4]) as $named
      | (($ranked | length) > 4) as $other
      | [$dates[] as $d | ($counted[$d] // {hours: 0}) as $c | ($prod[$d]) as $p | {
          date: $d,
          hours: $c.hours,
          accounts: (if $c.hours > 0 then $c.accounts else null end),
          messages: (if $c.hours > 0 then $c.messages else null end),
          media_bytes: (if $c.hours > 0 then $c.media_bytes else null end),
          total: (if $p == null then null else [$p[]] | add // 0 | round4 end),
          values: (if $p == null then null else
            ([$named[] as $n | ($p[$n] // 0)]
             + (if $other then [[$p | to_entries[] | select(.key as $k | $named | index($k) | not) | .value] | add // 0] else [] end)
             | map(round4)) end),
          dev: (if $devdays | has($d) then $devdays[$d] | round4 else null end)
        }] as $days
      | {
          month: $m,
          services: ($named + (if $other then ["Other"] else [] end)),
          # The total of each service that month, in the same order (Other last).
          service_totals: ([range(0; ($named | length) + (if $other then 1 else 0 end)) as $j
            | [$days[] | .values // [] | .[$j] // 0] | add // 0 | round4]),
          days: $days,
          totals: {
            hours: ($days | map(.hours) | add // 0),
            accounts: ($days | known(.accounts)),
            messages: ($days | known(.messages)),
            media_bytes: ($days | known(.media_bytes)),
            production: ($days | known(.total)),
            dev: ($days | known(.dev))
          }
        }]
  }' >"$out"
echo "statistics: $(jq -r '"\(.hours | length) hours, \(.months | length) months (\(.months | map(.month) | join(" "))), latest \(.latest)"' "$out")"
