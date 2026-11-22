---
title: "Verify the app"
linkTitle: "Verify"
description: "How anyone can check that the app Telegram opens is exactly the published code."
updated: "2026-11-21"
---

The encryption only protects you if the app you run is the published code. Inside Telegram, nothing stops whoever runs the bot from pointing it at a different page, so the app is published in a way anyone can check.

## How the app is published

- **Built in public.** A public workflow in [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) builds one release of [the code](https://github.com/{{< param "codeRepo" >}}), with no other code in that repository.
- **Reproducible.** The same release always builds into byte-identical files, so anyone can rebuild it and compare.
- **Signed in a public log.** Every file, and a `manifest.json` listing the SHA-256 of each one, is signed with [Sigstore](https://www.sigstore.dev/) by that workflow. The signatures are in a public transparency log that can't be quietly rewritten.
- **One address, nothing else on it.** The app is served only from `{{< param "appOrigin" >}}`, and nothing else is ever served there: a page on the same address could reach the keys on your device.
- **Locked down.** The app loads no third-party code, no analytics, and no code or settings from the server.

## Check it yourself

From a checkout of [the code](https://github.com/{{< param "codeRepo" >}}), with the GitHub CLI logged in:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

It checks that every file served is exactly what the unchanged, reviewed workflow built from a release on `main`, that the same workflow run deployed it, and that no other site shares the app's address. With `--rebuild` it also builds that release itself and compares byte for byte. The details, and what it doesn't prove, are in [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md).

## Checked automatically

The same script runs against the live app every hour, and once a day with `--rebuild`. The results, and what each check covers, are on the [Status](/status/) page.

## What this can't prove

- **What one person was shown inside Telegram.** The bot's owner could point the app at another address, for everyone or for chosen people. A page on another address has none of your keys; to get anywhere it would have to make you set up again, which ends your account loudly on your old device and changes your link.
- **What the server runs.** The design doesn't depend on it: a malicious server can drop or delay messages and watch timing, but can't read them or forge them, because the app checks every key itself. Proving the server's code is a future step (an attested enclave).
