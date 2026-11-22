# incognitochat.me

The website of [Incognito Chat](https://github.com/incognitochat/incognitochat):
what it is, its official addresses, how to verify the app, the latest
automatic checks of the app, and security reporting.

It's a static site built with [Hugo](https://gohugo.io/), in English and
Persian. It has no scripts, no cookies and no analytics, and loads nothing
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

## Working on it

```shell
hugo server            # http://localhost:1313
scripts/check.sh       # builds twice, compares, checks security.txt
```

Use the Hugo version in the workflow (`HUGO_VERSION`).

- Pages are in `content/` (`page.md` for English, `page.fa.md` for Persian).
- Every production address is in `hugo.toml` under `[params]`, in one place.
- Fonts are self-hosted: Inter, Newsreader (headings) and Vazirmatn
  (Persian), under the SIL Open Font License (`static/fonts/LICENSE-*`).
- `static/.well-known/security.txt` must be renewed before its `Expires`
  date; the check fails 30 days ahead.

## License

[AGPL-3.0](LICENSE), like the app.
