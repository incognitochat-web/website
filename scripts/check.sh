#!/usr/bin/env bash
# Checks every page and i18n key exists in every language, builds the site
# twice and fails unless both builds are byte for byte the same, then checks
# security.txt hasn't expired or come close to it.
# Usage: scripts/check.sh [output dir]   (default: public)
set -euo pipefail

out=${1:-public}
cd "$(dirname "$0")/.."

# Every page and every i18n key in every language, and the fonts each
# language preloads: a missing page would just drop out of that language's
# nav. hugo.toml and the i18n files are read as TOML.
python3 - <<'PY'
import pathlib, sys, tomllib

def fail(message):
    print(f"error: {message}", file=sys.stderr)
    sys.exit(1)

site = tomllib.loads(pathlib.Path("hugo.toml").read_text(encoding="utf-8"))
languages = site.get("languages", {})
if "en" not in languages or len(languages) < 2:
    fail(f"hugo.toml lists languages {sorted(languages)}: expected en and at least one more")
others = [lang for lang in languages if lang != "en"]

for lang, conf in languages.items():
    for font in conf.get("params", {}).get("fonts", []):
        if not pathlib.Path(f"static/fonts/{font}.woff2").is_file():
            fail(f"{lang} preloads static/fonts/{font}.woff2, which doesn't exist")

pages = sorted(pathlib.Path("content").rglob("*.md"))
names = {p.relative_to("content").as_posix() for p in pages}
for page in names:
    stem, _, _ = page.rpartition(".md")
    base, dot, suffix = stem.rpartition(".")
    if dot and suffix in languages:
        if suffix == "en" or f"{base}.md" not in names:
            fail(f"content/{page} has no English page content/{base}.md")
        continue
    for lang in others:
        if f"{stem}.{lang}.md" not in names:
            fail(f"content/{stem}.{lang}.md is missing")

def keys(lang):
    path = pathlib.Path(f"i18n/{lang}.toml")
    if not path.is_file():
        fail(f"{path} is missing")
    return set(tomllib.loads(path.read_text(encoding="utf-8")))

english = keys("en")
for lang in others:
    theirs = keys(lang)
    if theirs != english:
        fail(f"i18n/{lang}.toml's keys differ from i18n/en.toml's: missing {sorted(english - theirs)}, extra {sorted(theirs - english)}")
PY

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
