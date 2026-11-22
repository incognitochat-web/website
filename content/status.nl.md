---
title: "Status"
linkTitle: "Status"
description: "Automatische controles of de live app precies de gepubliceerde code is: elk uur, en elke dag ook met een nieuwe build uit de broncode."
---

{{< status >}}

## Zo werken deze controles

Een [geplande taak](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) in de openbare repository van deze site voert [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), uit de coderepository van de app, uit op de live app. Elk logboek is openbaar: open er een om elke controle en elk bestand te zien. Wil je dezelfde controles zelf uitvoeren, zie dan [De app verifiëren](/nl/verify/).
