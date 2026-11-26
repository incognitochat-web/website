---
title: "Status"
linkTitle: "Status"
description: "Automatische controles of de live app precies de gepubliceerde code is, elk uur en elke dag ook met een nieuwe build uit de broncode, en of de bot die app opent."
---

{{< status >}}

## Zo werken deze controles

Twee geplande taken in de openbare repository van deze site voeren de controles uit van de pagina [De app verifiëren](/nl/verify/), waar je ze ook zelf kunt uitvoeren: [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) controleert de live app elk uur, en bouwt hem één keer per dag ook opnieuw uit de broncode; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) controleert elk uur wat de bot opent, met een Telegram-account dat hiervoor is aangemaakt. Het logboek van elke run is openbaar. De botcontrole toont alleen wat dat account op dat moment te zien kreeg: wil je controleren wat jij te zien krijgt, [voer hem dan uit met je eigen account](/nl/verify/#bot-check).
