#!/usr/bin/env bash
# Turns the output of the code repository's scripts/verify-site.sh into the
# result the Status page shows: the overall result, the version checked, and
# a status for each check, read from the script's "ok" lines and the tags it
# prints for each kind of failure.
#
#   scripts/summarize-check.sh <log> <hourly|rebuild> <exit code> [checked_at]
#
# Statuses: passed, failed, warning (the site works but isn't the newest
# build), unknown (the script stopped before that check), na (the hourly
# check doesn't rebuild).
set -euo pipefail

log=${1:?usage: $0 <log> <hourly|rebuild> <exit code> [checked_at]}
mode=${2:?}
code=${3:?}
at=${4:-$(date -u +%Y-%m-%dT%H:%M:%SZ)}
case $mode in hourly | rebuild) ;; *) echo "mode must be hourly or rebuild" >&2; exit 2 ;; esac
case $code in 0) result=passed ;; 1) result=failed ;; *) result=error ;; esac

jq -R -s --arg mode "$mode" --arg result "$result" --arg at "$at" '
  split("\n") as $l
  | def seen($re): any($l[]; test($re));
    def status($ok; $bad):
      if seen($bad) then "failed" elif seen($ok) then "passed" else "unknown" end;
    ([$l[] | capture("^Built from \\S+ (?<ref>v[0-9]+\\.[0-9]+\\.[0-9]+|[0-9a-f]{40}) \\(commit [0-9a-f]{40}\\)$") | .ref]
    | first // "") as $ref
  | ([$l[] | select(test("^ok +[A-Za-z0-9._/-]+$") and (test("^ok +manifest\\.json$") | not))] | length) as $files
  | {
      mode: $mode,
      result: $result,
      checked_at: $at,
      ref: $ref,
      files: $files,
      checks: {
        address: status("^ok +only \\S+ has Pages$"; "^(OTHER PAGES SITE|NO PAGES) "),
        domain: status("^ok +\\S+ is served from its own address"; "^CUSTOM DOMAIN "),
        source: status("^ok +[0-9a-f]{40} is on "; "^(WRONG REPOSITORY|WRONG REF|WRONG TAG|NOT ON MAIN) "),
        latest: (if seen("^NOT LATEST ") then "warning"
          elif seen("^ok +\\S+ is (the latest release|the head of )") then "passed" else "unknown" end),
        signed: (if seen("^(UNREVIEWED WORKFLOW |UNATTESTED manifest\\.json$|Can.t fetch manifest\\.json|manifest\\.json isn.t|The manifest)") then "failed"
          elif seen("^ok +manifest\\.json$") and seen("^ok +signed by ") then "passed" else "unknown" end),
        deployed: status("^ok +deployed by run "; "^(OTHER DEPLOYER|UNKNOWN DEPLOY) "),
        files: (if seen("^Not fetching the files") then "unknown"
          elif seen("^(MISMATCH|MISSING|BAD PATH) ") or seen("^UNATTESTED (?!manifest\\.json$)") then "failed"
          elif $files > 0 then "passed" else "unknown" end),
        rebuild: (if $mode != "rebuild" then "na"
          elif seen("^(REBUILD FAILED|REBUILD DIFFERS|NOT IN MANIFEST) ") then "failed"
          elif seen("^Rebuild matches byte for byte$") then "passed" else "unknown" end)
      }
    }' "$log"
