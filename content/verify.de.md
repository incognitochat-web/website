---
title: "Die App prüfen"
linkTitle: "Prüfen"
description: "Wie jeder prüfen kann, ob die App, die Telegram öffnet, genau der veröffentlichte Code ist."
updated: "2026-11-26"
---

Die Verschlüsselung schützt dich nur, wenn die App, die du nutzt, der veröffentlichte Code ist. In Telegram hindert nichts den Betreiber des Bots daran, den Bot auf eine andere Seite umzustellen. Deshalb wird die App so veröffentlicht, dass jeder sie prüfen kann.

## So wird die App veröffentlicht

- **Öffentlich gebaut.** Ein öffentlicher Workflow in [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) baut ein Release [des Codes](https://github.com/{{< param "codeRepo" >}}), und sonst liegt kein Code in diesem Repository.
- **Reproduzierbar.** Dasselbe Release ergibt immer Byte für Byte identische Dateien, also kann jeder es neu bauen und vergleichen.
- **In einem öffentlichen Protokoll signiert.** Jede Datei und eine `manifest.json` mit dem SHA-256 jeder Datei werden von diesem Workflow mit [Sigstore](https://www.sigstore.dev/) signiert. Die Signaturen stehen in einem öffentlichen Transparenzprotokoll, das sich nicht unbemerkt umschreiben lässt.
- **Eine Adresse, sonst nichts darauf.** Die App wird nur von `{{< param "appOrigin" >}}` ausgeliefert, und dort wird nie etwas anderes ausgeliefert: Eine Seite unter derselben Adresse könnte an die Schlüssel auf deinem Gerät gelangen.
- **Abgeschottet.** Die App lädt keinen Code von Dritten, keine Webanalyse und weder Code noch Einstellungen vom Server.

## Prüf es selbst

In einer lokalen Kopie [des Codes](https://github.com/{{< param "codeRepo" >}}), mit angemeldeter GitHub CLI:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Das Skript prüft, ob jede ausgelieferte Datei genau das ist, was der unveränderte, geprüfte Workflow aus einem Release auf `main` gebaut hat, ob derselbe Lauf dieses Workflows sie bereitgestellt hat und ob keine andere Website die Adresse der App teilt. Mit `--rebuild` baut es dieses Release auch selbst und vergleicht Byte für Byte. Die Details, und was es nicht beweist, stehen in [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (auf Englisch).

## Prüf, was der Bot öffnet {#bot-check}

Wer den Bot betreibt, entscheidet, welche Adresse Telegram öffnet. Deshalb prüft [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py) die andere Hälfte so, wie dein eigenes Telegram-Konto sie sieht, ohne die App zu öffnen:

- die Links der App (`t.me/{{< param "botUsername" >}}?startapp`),
- den Menü-Button des Bots,
- den Button in der Antwort des Bots auf /start (das Skript schickt /start und löscht diese Nachrichten danach).

Jeder Link und jeder Button muss genau `{{< param "appOrigin" >}}/` öffnen. Du brauchst Python 3.11 oder neuer, eigene `api_id` und `api_hash` von [my.telegram.org](https://my.telegram.org) und deine Telegram-Anmeldung: Du gibst deine Telefonnummer und den Code ein, den Telegram dir schickt, die Anmeldung bleibt im Arbeitsspeicher, und das Skript meldet sich am Ende ab. In einer lokalen Kopie des Codes:

```shell
python3 -m venv ~/.cache/verify-bot
~/.cache/verify-bot/bin/pip install --require-hashes --only-binary :all: -r scripts/verify-bot.build.txt
~/.cache/verify-bot/bin/pip install --require-hashes --no-build-isolation -r scripts/verify-bot.requirements.txt
TG_API_ID=<id> TG_API_HASH=<hash> ~/.cache/verify-bot/bin/python scripts/verify-bot.py {{< param "botUsername" >}} {{< param "appOrigin" >}}
```

Die Details stehen in [Checking what the bot opens](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens) (auf Englisch).

## Automatisch geprüft

Beide Skripte laufen öffentlich nach Zeitplan: `verify-site.sh` jede Stunde gegen die live laufende App, und einmal am Tag mit `--rebuild`; `verify-bot.py` jede Stunde, mit einem eigens dafür angelegten Telegram-Konto. Die Ergebnisse stehen auf der Seite [Status](/de/status/).

## Was das nicht beweisen kann

- **Was anderen Personen in Telegram angezeigt wird.** Der Besitzer des Bots könnte die App auf eine andere Adresse umstellen, nur für ausgewählte Personen oder für ein paar Minuten zwischen den Prüfungen. Die stündliche Prüfung sieht nur, was ihrem eigenen Konto angezeigt wird, und dein eigener Lauf nur, was dir angezeigt wird. Eine Seite unter einer anderen Adresse hat keinen deiner Schlüssel; um etwas zu erreichen, müsste sie dich dazu bringen, die App neu einzurichten, was dein Konto auf deinem alten Gerät unübersehbar beendet und deinen Link ändert.
- **Was auf dem Server läuft.** Das Design hängt nicht davon ab: Ein bösartiger Server kann Nachrichten verwerfen oder verzögern und Zeitpunkte beobachten, aber er kann sie weder lesen noch fälschen, weil die App jeden Schlüssel selbst prüft. Nachzuweisen, was auf dem Server läuft, ist noch nicht möglich.
