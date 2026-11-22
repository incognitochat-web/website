---
title: "Sicherheit"
linkTitle: "Sicherheit"
description: "So meldest du eine Sicherheitslücke in Incognito Chat."
updated: "2026-11-21"
---

Du hast einen Weg gefunden, die Nachrichten anderer zu lesen, einen Absender seinem Konto zuzuordnen oder sonst etwas zu brechen, was die App verspricht? Bitte sag es uns zuerst vertraulich.

## So meldest du es

- **Am liebsten:** [melde es vertraulich auf GitHub](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Nur die Maintainer des Projekts sehen es.
- **Oder per E-Mail:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Sag uns, was du gefunden hast, wie man es nachstellt und was ein Angreifer damit tun könnte.

## Was dich erwartet

- Wir antworten innerhalb einer Woche und sagen dir, was wir unternehmen.
- Schwere Probleme beheben wir zuerst, und sobald die Nutzer sicher sind, veröffentlichen wir, was falsch war und wie es behoben wurde.
- Wenn du möchtest, nennen wir deinen Namen.

## Worum wir dich bitten

- Teste mit deinen eigenen Konten oder mit einer Kopie, die du selbst betreibst. Der [Code](https://github.com/{{< param "codeRepo" >}}) enthält alles, was du dafür brauchst.
- Greif nicht auf Daten anderer zu und stör den Dienst nicht für andere.
- Gib uns angemessen Zeit, das Problem zu beheben, bevor du etwas veröffentlichst.

Gegen Forschung, die auf diese Weise erfolgt, gehen wir nicht rechtlich vor.

## Was dazugehört

Die App, der Server, das Protokoll, die Build- und Veröffentlichungs-Pipeline und diese Website. Was das Design bereits als nicht schützbar einräumt, steht im [Sicherheitsmodell](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (auf Englisch); neue Wege, diese Grenzen auszunutzen, sind trotzdem willkommen.

Unsere [`security.txt`](/.well-known/security.txt) enthält dieselben Kontakte in einem Standardformat.
