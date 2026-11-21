#!/usr/bin/env bash
# Builds the site twice and fails unless both builds are byte for byte the
# same, then checks security.txt hasn't expired or come close to it.
# Usage: scripts/check.sh [output dir]   (default: public)
set -euo pipefail

out=${1:-public}
cd "$(dirname "$0")/.."

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

hugo --minify --cleanDestinationDir --destination "$tmp/first" >/dev/null
hugo --minify --cleanDestinationDir --destination "$out"
if ! diff -r "$tmp/first" "$out" >/dev/null; then
  echo "error: two builds of the same commit differ:" >&2
  diff -rq "$tmp/first" "$out" >&2 || true
  exit 1
fi

# RFC 9116: Expires is required; keep it more than 30 days ahead, so it is
# renewed before it lapses, and less than a year ahead.
expires=$(sed -n 's/^Expires: //p' static/.well-known/security.txt)
left=$(( ($(date -u -d "$expires" +%s) - $(date -u +%s)) / 86400 ))
if (( left < 30 )); then
  echo "error: security.txt expires in ${left} days ($expires): move Expires forward" >&2
  exit 1
fi
if (( left > 366 )); then
  echo "error: security.txt Expires is more than a year ahead ($expires)" >&2
  exit 1
fi

echo "ok: identical builds in $out; security.txt expires in ${left} days"
