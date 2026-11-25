---
title: "Status"
linkTitle: "Status"
description: "Automatische Prüfungen, ob die live laufende App genau der veröffentlichte Code ist, jede Stunde und einmal am Tag mit einem Neubau aus dem Quellcode, und ob der Bot die App öffnet."
---

{{< status >}}

## So funktionieren diese Prüfungen

Ein [geplanter Job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) im öffentlichen Repository dieser Website führt [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) aus dem Code-Repository der App gegen die live laufende App aus. Jedes Protokoll ist öffentlich: Öffne eines, um jede Prüfung und jede Datei zu sehen. Wie du dieselben Prüfungen selbst ausführst, steht unter [Die App prüfen](/de/verify/).

Ein weiterer [geplanter Job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) führt [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), ebenfalls aus dem Code-Repository der App, jede Stunde mit einem eigens dafür angelegten Telegram-Konto aus. Das Skript fragt Telegram, was die Links der App (`t.me/{{< param "botUsername" >}}?startapp`) und der Menü-Button des Bots öffnen, und schickt dem Bot /start, um den Button in seiner Antwort auszulesen, alles ohne die App zu öffnen. Das zeigt, was diesem Konto zu diesem Zeitpunkt ausgeliefert wurde: Ein Austausch, der nur auf ausgewählte Personen abzielt, oder ein kurzer Austausch zwischen zwei Prüfungen wäre hier nicht zu sehen. Um zu prüfen, was dir ausgeliefert wird, führe dasselbe Skript mit deinem eigenen Konto aus ([wie, auf Englisch](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
