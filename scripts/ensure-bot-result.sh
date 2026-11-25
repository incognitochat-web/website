#!/usr/bin/env bash
# For .github/workflows/check-bot.yml: if the given file isn't a result of
# scripts/verify-bot.py (missing, cut off, not one of its results), writes a
# "couldn't run" one and prints "wrote", so the Status page says the check
# couldn't run rather than keep an older result. A real result is kept.
#
#   scripts/ensure-bot-result.sh <bot-check.json>
set -euo pipefail

result=${1:?usage: $0 <bot-check.json>}
if jq -e '.result | IN("passed", "failed", "error")' "$result" >/dev/null 2>&1; then
  exit 0
fi
mkdir -p "$(dirname "$result")"
jq -n --arg at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  '{result: "error", checked_at: $at, bot_id: null, checks: {bot: "unknown", main: "unknown", menu: "unknown", welcome: "unknown"}}' >"$result"
echo wrote
