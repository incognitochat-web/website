---
title: "Die App prüfen"
linkTitle: "Prüfen"
description: "Wie jeder prüfen kann, ob die App, die Telegram öffnet, genau der veröffentlichte Code ist."
updated: "2026-11-21"
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

## Automatisch geprüft

Dasselbe Skript prüft die live laufende App jede Stunde, und einmal am Tag mit `--rebuild`. Die Ergebnisse, und was jede Prüfung abdeckt, stehen auf der Seite [Status](/de/status/).

## Was das nicht beweisen kann

- **Was einer Person in Telegram angezeigt wurde.** Der Besitzer des Bots könnte die App auf eine andere Adresse umstellen, für alle oder für ausgewählte Personen. Eine Seite unter einer anderen Adresse hat keinen deiner Schlüssel; um etwas zu erreichen, müsste sie dich dazu bringen, die App neu einzurichten, was dein Konto auf deinem alten Gerät unübersehbar beendet und deinen Link ändert.
- **Was auf dem Server läuft.** Das Design hängt nicht davon ab: Ein bösartiger Server kann Nachrichten verwerfen oder verzögern und Zeitpunkte beobachten, aber er kann sie weder lesen noch fälschen, weil die App jeden Schlüssel selbst prüft. Nachzuweisen, welcher Code auf dem Server läuft, ist ein späterer Schritt (eine attestierte Enklave).
