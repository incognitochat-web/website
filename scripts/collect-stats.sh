#!/usr/bin/env bash
# Reads the app's public statistics from AWS into the data store (the
# repository's `data` branch, checked out at <store>), for the Stats and
# Costs pages.
# Run by .github/workflows/stats.yml with a read-only role
# (the code repository's infra/init/stats_reader.tf); anyone with such a
# role can run it the same way.
#
#   scripts/collect-stats.sh counts <store>        hourly counts (needs NAMESPACE, AWS_REGION)
#   scripts/collect-stats.sh costs <account> <store>   daily costs; account: production or dev
#
# counts reads three metrics, an hour at a time, for the last 7 days of
# complete hours, and writes them into stats/hourly/<yyyy-mm-dd>.json. A
# metric's data point is dated by when its line was logged, which can be
# much later than the minute it counts, so late counts land in a later hour.
# Each run reads the 7 days again and overwrites them, so runs late or
# missed for up to a week leave no gap (GetMetricData costs the same for
# any window). An hour with no data point counted nothing (the metrics only
# get data when there's something to count); but if no metric has a single
# data point in the whole window while the store has counts in it, the
# namespace is probably wrong, and nothing is written.
#
# costs reads Cost Explorer's daily costs from the start of last month to
# yesterday (today isn't over; AWS revises recent days, and a month's last
# days arrive in the next), before credits and refunds, following
# NextPageToken, and writes stats/costs/<account>/<yyyy-mm>.json:
# production by service, dev as one total. Cost Explorer charges $0.01 a
# call, so the workflow reads costs once a day.
#
# COSTS_FROM (yyyy-mm-dd), when set, is the first day costs are read: set it
# to the day an AWS account moves to another AWS organization. Cost Explorer
# then hides what the account cost before the move, and reading those days
# again would overwrite them with nothing. Months before that day are left as
# stored. That day's month keeps its stored file too: the days from that day
# on go into their own file, stats/costs/<account>/<yyyy-mm>-from-<dd>.json,
# so a file this writes (and the workflow signs) holds only what AWS
# answered, never anything copied from the store. On the 1st of a month, the
# month is read whole into its usual file. Never a day in the future; on the
# day itself there's nothing to read yet.
#
# Files are written with sorted keys and fixed formatting, so a run that
# reads nothing new changes nothing.
set -euo pipefail
# Hours and days are UTC whatever the machine's time zone: the CLI prints
# CloudWatch's timestamps in local time otherwise.
export TZ=UTC
export LC_ALL=C

usage() {
  echo "usage: $0 counts <store> | $0 costs <production|dev> <store>" >&2
  exit 2
}

kind=${1:-}
case $kind in
  counts) [ $# -eq 2 ] || usage; store=$2 ;;
  costs) [ $# -eq 3 ] || usage; account=$2; store=$3
    case $account in production | dev) ;; *) usage ;; esac ;;
  *) usage ;;
esac
[ -d "$store" ] || { echo "no store at $store" >&2; exit 2; }
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# The store is a checkout anyone with push access to its branch could put
# links in: refuse a link, or anything but a plain file or folder, on the
# way to a file this writes, so nothing outside the store is read or
# overwritten.
plain() { # path relative to the store
  local path=$store part
  for part in ${1//\// }; do
    path=$path/$part
    if [ -L "$path" ] || { [ -e "$path" ] && [ ! -f "$path" ] && [ ! -d "$path" ]; }; then
      echo "$path isn't a plain file or folder; nothing written" >&2
      exit 1
    fi
  done
}

counts() {
  : "${NAMESPACE:?NAMESPACE, the namespace of the counts, is needed}" "${AWS_REGION:?AWS_REGION is needed}"
  local end start
  end=$(date -u +%Y-%m-%dT%H:00:00Z)
  start=$(date -u -d "${end} - 168 hours" +%Y-%m-%dT%H:00:00Z)
  # Metric name => the field it fills.
  jq -n --arg ns "$NAMESPACE" '[
    {Id: "accounts", MetricStat: {Metric: {Namespace: $ns, MetricName: "Registrations"}, Period: 3600, Stat: "Sum"}},
    {Id: "messages", MetricStat: {Metric: {Namespace: $ns, MetricName: "Messages"}, Period: 3600, Stat: "Sum"}},
    {Id: "media_bytes", MetricStat: {Metric: {Namespace: $ns, MetricName: "MediaBytes"}, Period: 3600, Stat: "Sum"}}
  ]' >"$tmp/queries.json"
  aws cloudwatch get-metric-data --region "$AWS_REGION" --output json \
    --metric-data-queries "file://$tmp/queries.json" \
    --start-time "$start" --end-time "$end" --scan-by TimestampAscending >"$tmp/metrics.json"
  if jq -e '[.MetricDataResults[].StatusCode] | any(. != "Complete")' "$tmp/metrics.json" >/dev/null; then
    echo "CloudWatch didn't return complete data; nothing written" >&2
    exit 1
  fi

  # Every hour of the window, with what each metric counted (0 without a
  # data point), grouped by day.
  local day file
  # No data point at all, where the store has counts in those same hours:
  # probably the wrong namespace. Don't overwrite real history with zeros.
  # (A namespace wrong from the very first run can't be told from a quiet
  # week: the store then only gets zeros.)
  plain stats/hourly
  if jq -e '[.MetricDataResults[].Values | length] | add == 0' "$tmp/metrics.json" >/dev/null; then
    local stored=()
    mapfile -t stored < <(find "$store/stats/hourly" -maxdepth 1 -type f -name '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9].json' 2>/dev/null | sort)
    # jq -e: 0 if the store has counts there, 1 if not; anything else means
    # a stored file couldn't be read, and then it can't tell either.
    local found=1
    if [ ${#stored[@]} -gt 0 ]; then
      found=0
      jq -se --arg start "${start:0:13}" '
        [.[] | .date as $d | (.accounts, .messages, .media_bytes) | to_entries[]
         | select(.value != null and .value > 0)
         | select(($d + "T" + (if .key < 10 then "0" else "" end) + (.key | tostring)) >= $start)] | length > 0' \
        "${stored[@]}" >/dev/null || found=$?
    fi
    case $found in
      0) echo "No data points in the whole window, but the store has counts there: is the namespace right? Nothing written" >&2
         exit 1 ;;
      1) ;;
      *) echo "No data points in the whole window, and the stored counts couldn't be read to compare; nothing written" >&2
         exit 1 ;;
    esac
  fi
  for ((h = 0; h < 168; h++)); do
    date -u -d "${start} + ${h} hours" +%Y-%m-%dT%H:00:00Z
  done >"$tmp/hours.txt"
  while read -r day; do
    plain "stats/hourly/$day.json"
    file=$store/stats/hourly/$day.json
    mkdir -p "$(dirname "$file")"
    [ -f "$file" ] || jq -n --arg day "$day" '{date: $day, accounts: [range(24) | null], messages: [range(24) | null], media_bytes: [range(24) | null]}' >"$file"
    jq -S --arg day "$day" --rawfile hours "$tmp/hours.txt" --slurpfile m "$tmp/metrics.json" '
      ($m[0].MetricDataResults | map({key: .Id, value: ([.Timestamps, .Values] | transpose | map({key: (.[0] | sub("(:00)?(\\+00:00|Z)$"; "") | .[0:13]), value: .[1]}) | from_entries)}) | from_entries) as $byId
      | reduce ($hours | split("\n")[] | select(startswith($day))) as $hour (.;
          ($hour[11:13] | tonumber) as $h
          | reduce ("accounts", "messages", "media_bytes") as $id (.;
              .[$id][$h] = (($byId[$id][$hour[0:13]] // 0) | round)))
    ' "$file" >"$tmp/day.json"
    mv "$tmp/day.json" "$file"
  done < <(cut -c1-10 "$tmp/hours.txt" | sort -u)
  echo "counts: $(cut -c1-10 "$tmp/hours.txt" | sort -u | tr '\n' ' ')"
}

costs() {
  local first end month name file token='' page=0 from=${COSTS_FROM:-}
  first=$(date -u -d "$(date -u +%Y-%m-01) - 1 month" +%Y-%m-01)
  # Up to yesterday: End is exclusive, and today isn't over.
  end=$(date -u +%Y-%m-%d)
  if [ -n "$from" ]; then
    # A real date, the years the Costs page can show.
    if [[ ! $from =~ ^20[0-9]{2}-[0-9]{2}-[0-9]{2}$ ]] || [ "$(date -u -d "$from" +%Y-%m-%d 2>/dev/null)" != "$from" ]; then
      echo "COSTS_FROM isn't a date (yyyy-mm-dd): '$from'; nothing written" >&2
      exit 1
    fi
    # Set ahead of time, it would stop the days before it from being read
    # while they still can be.
    if [[ $from > $end ]]; then
      echo "COSTS_FROM ($from) is in the future: set it on the day of the move; nothing written" >&2
      exit 1
    fi
    [[ $from > $first ]] && first=$from
    if [ "$first" = "$end" ]; then
      echo "costs ($account): from $from, nothing to read yet"
      return 0
    fi
  fi
  local group=()
  # shellcheck disable=SC2054 # one argument with commas, as the CLI takes it
  [ "$account" = production ] && group=(--group-by Type=DIMENSION,Key=SERVICE)
  # Before credits and refunds: what running the service costs. The answer
  # can come in pages; every page is read.
  echo '[]' >"$tmp/results.json"
  while :; do
    page=$((page + 1))
    [ $page -le 20 ] || { echo "Cost Explorer kept paging; nothing written" >&2; exit 1; }
    aws ce get-cost-and-usage --region us-east-1 --output json \
      --time-period "Start=${first},End=${end}" --granularity DAILY --metrics UnblendedCost \
      --filter '{"Not": {"Dimensions": {"Key": "RECORD_TYPE", "Values": ["Credit", "Refund"]}}}' \
      "${group[@]}" ${token:+--next-page-token "$token"} >"$tmp/page.json"
    jq -s '.[0] + .[1].ResultsByTime' "$tmp/results.json" "$tmp/page.json" >"$tmp/merged.json"
    mv "$tmp/merged.json" "$tmp/results.json"
    token=$(jq -r '.NextPageToken // empty' "$tmp/page.json")
    [ -n "$token" ] || break
  done
  # Pages can split a day's groups: put each day's back together.
  jq '{ResultsByTime: (group_by(.TimePeriod.Start) | map({TimePeriod: .[0].TimePeriod, Estimated: (map(.Estimated) | any),
       Total: .[0].Total, Groups: (map(.Groups // []) | add)}))}' "$tmp/results.json" >"$tmp/costs.json"
  while read -r month; do
    # The month reading starts in, when it starts after the 1st: its own file.
    name=$month
    if [ -n "$from" ] && [ "$month" = "${from:0:7}" ] && [ "${from:8:2}" != 01 ]; then
      name=$month-from-${from:8:2}
    fi
    plain "stats/costs/$account/$name.json"
    file=$store/stats/costs/$account/$name.json
    mkdir -p "$(dirname "$file")"
    jq -S --arg month "$month" --arg account "$account" --arg from "$from" --argjson cut "$([ "$name" = "$month" ] && echo false || echo true)" '
      def amount: tonumber | (. * 10000 | round) / 10000;
      # Never a day before COSTS_FROM, whatever the answer holds.
      .ResultsByTime |= map(select(.TimePeriod.Start >= $from))
      | {
        month: $month,
        currency: "USD",
        days: ([.ResultsByTime[] | select(.TimePeriod.Start | startswith($month)) | {
          key: .TimePeriod.Start,
          value: (if $account == "production"
            then ([.Groups[] | {key: .Keys[0], value: (.Metrics.UnblendedCost.Amount | amount)} | select(.value != 0)] | from_entries)
            else (.Total.UnblendedCost.Amount | amount) end)
        }] | from_entries),
        estimated: [.ResultsByTime[] | select(.TimePeriod.Start | startswith($month)) | select(.Estimated) | .TimePeriod.Start]
      } + (if $cut then {from: $from} else {} end)' "$tmp/costs.json" >"$tmp/month.json"
    mv "$tmp/month.json" "$file"
  done < <(jq -r '.ResultsByTime[].TimePeriod.Start[0:7]' "$tmp/costs.json" | sort -u)
  echo "costs ($account): from $first"
}

"$kind"
