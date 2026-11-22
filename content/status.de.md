---
title: "Status"
linkTitle: "Status"
description: "Automatische Prüfungen, ob die live laufende App genau der veröffentlichte Code ist: jede Stunde und jeden Tag mit einem Neubau aus dem Quellcode."
---

{{< status >}}

## So funktionieren diese Prüfungen

Ein [geplanter Job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) im öffentlichen Repository dieser Website führt [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) aus dem Code-Repository der App gegen die live laufende App aus. Jedes Protokoll ist öffentlich: Öffne eines, um jede Prüfung und jede Datei zu sehen. Wie du dieselben Prüfungen selbst ausführst, steht unter [Die App prüfen](/de/verify/).
