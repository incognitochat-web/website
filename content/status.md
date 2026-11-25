---
title: "Status"
linkTitle: "Status"
description: "Automatic checks that the live app is exactly the published code, every hour and every day with a rebuild from source, and that the bot opens it."
---

{{< status >}}

## How these checks work

A [scheduled job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) in this site's public repository runs [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), from the app's code repository, against the live app. Every log is public: open one to see each check and each file. To run the same checks yourself, see [Verify the app](/verify/).

Another [scheduled job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) runs [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), also from the app's code repository, every hour with a Telegram account made for this. It asks Telegram what the app's links (`t.me/{{< param "botUsername" >}}?startapp`) and the bot's menu button open, and sends the bot /start to read the button in its reply, all without opening the app. This shows what that account was served at that moment: a swap aimed only at chosen people, or a short one between two checks, wouldn't show here. To check what you are served, run the same script with your own account ([how, in English](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
