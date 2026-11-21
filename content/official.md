---
title: "Official addresses"
linkTitle: "Official"
description: "The one real bot, the app's address, and where the code lives. Anything else isn't us."
updated: "2026-11-21"
---

These are the only official addresses of Incognito Chat. **Anything else is not us**, however close the name: copies of the bot or the app can't be trusted with your messages.

{{< official >}}

## How to tell

- **The bot's username is exactly `@{{< param "botUsername" >}}`.** Check every letter: look-alike names are the most common trick.
- **The app is always served from `{{< param "appOrigin" >}}`.** Your keys are tied to that address, so a page served from anywhere else starts without them: it can't read your past messages, and it would have to ask you to set up again.
- **The bot only sends a short welcome and "New message" notices.** A notice never says who wrote or what, and the bot never asks you to set up again or to open another link.
- **Setting up again is never needed** unless you chose to start over. If the app asks you to set up when you didn't choose to, don't: you're not in the real app. Close it, make sure you opened it from `@{{< param "botUsername" >}}`, and if you did, tell us at [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

## Where this list lives

This page is built from [the site's public repository](https://github.com/{{< param "siteRepo" >}}), so every change to it has a public date.
