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

def toml(path):
    try:
        return tomllib.loads(pathlib.Path(path).read_text(encoding="utf-8"))
    except tomllib.TOMLDecodeError as err:
        fail(f"{path}: {err}")

site = toml("hugo.toml")
languages = site.get("languages", {})
if "en" not in languages or len(languages) < 2:
    fail(f"hugo.toml lists languages {sorted(languages)}: expected en and at least one more")
others = [lang for lang in languages if lang != "en"]

for lang, conf in languages.items():
    for font in conf.get("params", {}).get("fonts", []):
        if not pathlib.Path(f"static/fonts/{font}.woff2").is_file():
            fail(f"{lang} preloads static/fonts/{font}.woff2, which doesn't exist")

names = {p.relative_to("content").as_posix() for p in pathlib.Path("content").rglob("*.md")}
for page in sorted(names):
    stem, _, _ = page.rpartition(".md")
    base, dot, suffix = stem.rpartition(".")
    if dot and suffix in languages:
        if suffix == "en":
            fail(f"content/{page}: name English pages without .en (content/{base}.md)")
        if f"{base}.md" not in names:
            fail(f"content/{page} has no English page content/{base}.md")
        continue
    for lang in others:
        if f"{stem}.{lang}.md" not in names:
            fail(f"content/{stem}.{lang}.md is missing")

def keys(lang):
    path = pathlib.Path(f"i18n/{lang}.toml")
    if not path.is_file():
        fail(f"{path} is missing")
    return set(toml(path))

english = keys("en")
for lang in others:
    theirs = keys(lang)
    if theirs != english:
        fail(f"i18n/{lang}.toml's keys differ from i18n/en.toml's: missing {sorted(english - theirs)}, extra {sorted(theirs - english)}")

# The Status page's rows and the Donate page's amounts go into the page as
# HTML (status.html, collective.html): no markup in them. And the bot's rows and group line take its handle, link, ID, /start
# and the app's address as placeholders the page keeps left to right, never
# typed in.
needs = {"st_group_bot_desc": ["{{ .Address }}"], "st_bot_bot_desc": ["{{ .Handle }}", "{{ .ID }}"], "st_bot_main_desc": ["{{ .Link }}"],
         "st_bot_welcome": ["{{ .Start }}"], "st_bot_welcome_desc": ["{{ .Start }}"],
         "oc_per_month": ["{{ .Amount }}"], "oc_per_year": ["{{ .Amount }}"]}
for lang in ["en", *others]:
    strings = toml(pathlib.Path(f"i18n/{lang}.toml"))
    for key, value in strings.items():
        if (key.startswith(("st_", "oc_")) or key == "newTab") and any(c in str(value) for c in "<>&"):
            fail(f"i18n/{lang}.toml: {key} has <, > or &, which the page would read as HTML")
        if (key.startswith("st_bot_") or key == "st_group_bot_desc") and any(t in str(value) for t in ("/start", "@", "t.me/", "https://", "github.io")):
            fail(f"i18n/{lang}.toml: {key} types the bot's handle, link, /start or the app's address in; use the placeholders (kept left to right)")
    for key, placeholders in needs.items():
        if any(p not in str(strings.get(key, "")) for p in placeholders):
            fail(f"i18n/{lang}.toml: {key} must use {placeholders}")
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

# Every link and resource on the site, in every language, leads to a file of
# the build, and every #anchor to an id on its page: a page removed or
# renamed (or a heading's anchor) can't leave a link going nowhere.
python3 -I - "$out" <<'PY'
import html.parser, pathlib, sys, tomllib, urllib.parse
out = pathlib.Path(sys.argv[1])
site = urllib.parse.urlparse(tomllib.load(open("hugo.toml", "rb"))["baseURL"])

class Page(html.parser.HTMLParser):
    def __init__(self):
        super().__init__()
        self.links, self.ids = [], set()
    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if name == "id" and value:
                self.ids.add(value)
            if name in ("href", "src") and value:
                self.links.append(value)

pages = {}
for path in out.rglob("*.html"):
    page = Page()
    page.feed(path.read_text(encoding="utf-8"))
    pages[path] = page

def target(path):  # a URL path -> the file it serves, or None
    file = out / urllib.parse.unquote(path).lstrip("/")
    if path.endswith("/") or file.is_dir():
        file = file / "index.html"
    return file if file.is_file() else None

bad = []
for path, page in pages.items():
    here = "/" + str(path.relative_to(out)).removesuffix("index.html")
    for link in page.links:
        url = urllib.parse.urlparse(urllib.parse.urljoin(site.geturl().rstrip("/") + here, link))
        if url.scheme not in ("http", "https") or url.netloc != site.netloc:
            continue
        file = target(url.path)
        if file is None:
            bad.append(f"{path.relative_to(out)}: {link} leads to no page")
        elif url.fragment and file.suffix == ".html" and url.fragment not in pages[file].ids:
            bad.append(f"{path.relative_to(out)}: {link} has no #{url.fragment} on its page")
if bad:
    print("error: links going nowhere:\n  " + "\n  ".join(sorted(set(bad))[:40]), file=sys.stderr)
    sys.exit(1)
PY

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
