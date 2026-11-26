---
title: "Status"
linkTitle: "Status"
description: "Automatische Prüfungen, ob die live laufende App genau der veröffentlichte Code ist, jede Stunde und einmal am Tag mit einem Neubau aus dem Quellcode, und ob der Bot die App öffnet."
---

{{< status >}}

## So funktionieren diese Prüfungen

Zwei geplante Jobs im öffentlichen Repository dieser Website führen die Prüfungen von der Seite [Die App prüfen](/de/verify/) aus, wo du sie auch selbst ausführen kannst: [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) prüft die live laufende App jede Stunde und baut sie einmal am Tag auch aus dem Quellcode neu; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) prüft jede Stunde mit einem eigens dafür angelegten Telegram-Konto, was der Bot öffnet. Das Protokoll jedes Laufs ist öffentlich. Die Bot-Prüfung zeigt nur, was diesem Konto zu diesem Zeitpunkt angezeigt wurde: Um zu prüfen, was dir angezeigt wird, [führe sie mit deinem eigenen Konto aus](/de/verify/#bot-check).
