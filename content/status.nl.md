---
title: "Status"
linkTitle: "Status"
description: "Automatische controles of de live app precies de gepubliceerde code is, elk uur en elke dag ook met een nieuwe build uit de broncode, en of de bot die app opent."
---

{{< status >}}

## Zo werken deze controles

Een [geplande taak](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) in de openbare repository van deze site gebruikt [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) uit de coderepository van de app om de live app te controleren. Elk logboek is openbaar: open er een om elke controle en elk bestand te zien. Wil je dezelfde controles zelf uitvoeren, zie dan [De app verifiëren](/nl/verify/).

Een andere [geplande taak](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) gebruikt elk uur [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), ook uit de coderepository van de app, met een Telegram-account dat hiervoor is aangemaakt. Het script vraagt Telegram wat de links van de app (`t.me/{{< param "botUsername" >}}?startapp`) en de menuknop van de bot openen, en stuurt /start naar de bot om de knop in zijn antwoord te lezen, allemaal zonder de app te openen. Dit toont wat dat account op dat moment te zien kreeg: een omwisseling die alleen op uitgekozen mensen is gericht, of een korte omwisseling tussen twee controles in, zou hier niet zichtbaar zijn. Wil je controleren wat jij te zien krijgt, voer dan hetzelfde script uit met je eigen account ([hoe, in het Engels](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
