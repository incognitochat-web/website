# incognitochat.me

The website of [Incognito Chat](https://github.com/incognitochat/incognitochat):
what it is, its official addresses, how to verify the app, the latest
automatic checks of the app, and security reporting.

It's a static site built with [Hugo](https://gohugo.io/), in English,
Persian, Russian, Arabic, Dutch, Spanish, Brazilian Portuguese, Indonesian and Turkish. It has no scripts, no cookies and no analytics, and loads nothing
from anywhere else.

## How it's published

Only by [`.github/workflows/deploy.yml`](.github/workflows/deploy.yml), on
GitHub Pages, from `main`:

- Hugo is a pinned release, checked against its SHA-256.
- The site is built twice and both builds must be byte for byte the same.
- `manifest.json` lists the commit, the Hugo version and the SHA-256 of every
  file. Every file is signed with Sigstore by that workflow, so anyone can
  check what's served against this repository:

  ```shell
  gh attestation verify <file> --repo incognitochat-web/website \
    --cert-identity https://github.com/incognitochat-web/website/.github/workflows/deploy.yml@refs/heads/main
  ```

Every change to the official addresses is a commit here, with its date.

## Checking the app

[`.github/workflows/check-app.yml`](.github/workflows/check-app.yml) runs the
code repository's `scripts/verify-site.sh` against the live app every hour,
and once a day with `--rebuild`. `scripts/summarize-check.sh` turns its output
into one status per check; each run uploads that and redeploys this site.
The deploy fetches the latest results (`scripts/fetch-app-checks.sh`, into
`data/appcheck.json`, not committed) for the Status page.

## Statistics

[`.github/workflows/stats.yml`](.github/workflows/stats.yml) reads the app's
hourly counts every hour, and its costs once a day, with read-only AWS roles
that only this repository's `stats` environment may assume (the code
repository's `infra/init/stats_reader.tf`, set up by its
`scripts/bootstrap.sh` with `STATS_REPO`). `scripts/collect-stats.sh` writes
them into the `data` branch, one file per day of counts and per month of
costs; the workflow signs each file it writes (Sigstore) and redeploys the
site. The deploy turns the branch into `data/stats.json`
(`scripts/build-stats.sh`, not committed) for the Stats page (usage) and the
Costs page: the newest 13 months, one shown at a time. Each count shows from the hour
`params.statsCountedFrom` in `hugo.toml` says production first counted it.
What each number counts, and how to check the signed files, is in
[`docs/statistics.md`](docs/statistics.md).

## Working on it

```shell
hugo server            # http://localhost:1313
scripts/check.sh       # every page and string in every language; builds twice, compares; security.txt
```

Use the Hugo version in the workflow (`HUGO_VERSION`). `scripts/check.sh` also
needs Python 3.11 or newer (it reads the TOML files).

- Pages are in `content/`: `page.md` for English, `page.<code>.md` for each
  other language in `hugo.toml` (`fa`, `ru`, `ar`, `nl`, `es`, `pt-br`, `id`, `tr`).
- Every production address is in `hugo.toml` under `[params]`, in one place.
- Fonts are self-hosted: Inter, Newsreader (headings) and Vazirmatn
  (Persian and Arabic), under the SIL Open Font License
  (`static/fonts/LICENSE-*`). Inter and Newsreader are subsets with no
  Cyrillic, nor Turkish's ğ, ş and İ, so Russian and Turkish text use the
  system's fonts.
- `static/.well-known/security.txt` must be renewed before its `Expires`
  date; the check fails 30 days ahead.

## License

[AGPL-3.0](LICENSE), like the app.
