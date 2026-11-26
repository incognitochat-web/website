---
title: "Status"
linkTitle: "Status"
description: "Automatic checks that the live app is exactly the published code, every hour and every day with a rebuild from source, and that the bot opens the app."
---

{{< status >}}

## How these checks work

Two scheduled jobs in this site's public repository run the checks from [Verify the app](/verify/), where you can also run them yourself: [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) checks the live app every hour, and once a day also rebuilds it from source; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) checks what the bot opens every hour, with a Telegram account made for this. Every run's log is public. The bot check shows only what that account was shown at that moment: to check what you are shown, [run it with your own account](/verify/#bot-check).
