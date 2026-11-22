#!/usr/bin/env bash
# Reads the app's public statistics from AWS into the data store (the
# repository's `data` branch, checked out at <store>), for the Stats page.
# Run by .github/workflows/stats.yml with a read-only role
# (the code repository's infra/init/stats_reader.tf); anyone with such a
# role can run it the same way.
#
#   scripts/collect-stats.sh counts <store>        hourly counts (needs NAMESPACE, AWS_REGION)
#   scripts/collect-stats.sh costs <account> <store>   daily costs; account: production or dev
#
# counts reads three metrics, an hour at a time, for the last 48 complete
# hours, and writes them into stats/hourly/<yyyy-mm-dd>.json. A metric's
# data point is dated by when its line was logged, which can be a while
# after the minute it counts, so late counts land in a later hour. Each run
# reads the 48 hours again and overwrites them, so a late or missed run
# leaves no gap, and CloudWatch's own short delay is caught up. An hour
# with no data point counted nothing (the metrics only get data when
# there's something to count).
#
# costs reads Cost Explorer's daily costs from the start of last month (AWS
# revises recent days, and this month's last days arrive next month), before
# credits and refunds, and writes stats/costs/<account>/<yyyy-mm>.json:
# production by service, dev as one total. Cost Explorer charges $0.01 a
# call, so the workflow reads costs once a day.
#
# Files are written with sorted keys and fixed formatting, so a run that
# reads nothing new changes nothing.
set -euo pipefail

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

counts() {
  : "${NAMESPACE:?NAMESPACE, the namespace of the counts, is needed}" "${AWS_REGION:?AWS_REGION is needed}"
  local end start
  end=$(date -u +%Y-%m-%dT%H:00:00Z)
  start=$(date -u -d "${end} - 48 hours" +%Y-%m-%dT%H:00:00Z)
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
  for ((h = 0; h < 48; h++)); do
    date -u -d "${start} + ${h} hours" +%Y-%m-%dT%H:00:00Z
  done >"$tmp/hours.txt"
  while read -r day; do
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
  local first end month file
  first=$(date -u -d "$(date -u +%Y-%m-01) - 1 month" +%Y-%m-01)
  end=$(date -u -d tomorrow +%Y-%m-%d)
  local group=()
  # shellcheck disable=SC2054 # one argument with commas, as the CLI takes it
  [ "$account" = production ] && group=(--group-by Type=DIMENSION,Key=SERVICE)
  # Before credits and refunds: what running the service costs.
  aws ce get-cost-and-usage --region us-east-1 --output json \
    --time-period "Start=${first},End=${end}" --granularity DAILY --metrics UnblendedCost \
    --filter '{"Not": {"Dimensions": {"Key": "RECORD_TYPE", "Values": ["Credit", "Refund"]}}}' \
    "${group[@]}" >"$tmp/costs.json"
  while read -r month; do
    file=$store/stats/costs/$account/$month.json
    mkdir -p "$(dirname "$file")"
    jq -S --arg month "$month" --arg account "$account" '
      def amount: tonumber | (. * 10000 | round) / 10000;
      {
        month: $month,
        currency: "USD",
        days: ([.ResultsByTime[] | select(.TimePeriod.Start | startswith($month)) | {
          key: .TimePeriod.Start,
          value: (if $account == "production"
            then ([.Groups[] | {key: .Keys[0], value: (.Metrics.UnblendedCost.Amount | amount)} | select(.value != 0)] | from_entries)
            else (.Total.UnblendedCost.Amount | amount) end)
        }] | from_entries),
        estimated: [.ResultsByTime[] | select(.TimePeriod.Start | startswith($month)) | select(.Estimated) | .TimePeriod.Start]
      }' "$tmp/costs.json" >"$tmp/month.json"
    mv "$tmp/month.json" "$file"
  done < <(jq -r '.ResultsByTime[].TimePeriod.Start[0:7]' "$tmp/costs.json" | sort -u)
  echo "costs ($account): from $first"
}

"$kind"
