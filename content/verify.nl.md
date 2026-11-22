---
title: "De app verifiëren"
linkTitle: "Verifiëren"
description: "Zo kan iedereen controleren of de app die Telegram opent precies de gepubliceerde code is."
updated: "2026-11-21"
---

De versleuteling beschermt je alleen als de app die je gebruikt de gepubliceerde code is. Binnen Telegram houdt niets degene die de bot beheert tegen om hem naar een andere pagina te laten verwijzen, dus wordt de app zo gepubliceerd dat iedereen hem kan controleren.

## Zo wordt de app gepubliceerd

- **Openbaar gebouwd.** Een openbare workflow in [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) bouwt één release van [de code](https://github.com/{{< param "codeRepo" >}}), zonder andere code in die repository.
- **Reproduceerbaar.** Dezelfde release levert altijd byte voor byte dezelfde bestanden op, dus iedereen kan hem opnieuw bouwen en vergelijken.
- **Ondertekend in een openbaar logboek.** Elk bestand, en een `manifest.json` met de SHA-256 van elk bestand, wordt door die workflow ondertekend met [Sigstore](https://www.sigstore.dev/). De handtekeningen staan in een openbaar transparantielogboek dat niet ongemerkt kan worden herschreven.
- **Eén adres, en verder niets erop.** De app wordt alleen geladen vanaf `{{< param "appOrigin" >}}`, en daar wordt nooit iets anders aangeboden: een pagina op hetzelfde adres zou bij de sleutels op je apparaat kunnen komen.
- **Dichtgetimmerd.** De app laadt geen code van derden, geen analysetools, en geen code of instellingen van de server.

## Controleer het zelf

In een lokale kopie van [de code](https://github.com/{{< param "codeRepo" >}}), met de GitHub CLI ingelogd:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Het script controleert of elk geleverd bestand precies is wat de ongewijzigde, nagekeken workflow heeft gebouwd uit een release op `main`, of dezelfde run van die workflow het heeft uitgerold, en of er geen andere site is die het adres van de app deelt. Met `--rebuild` bouwt het die release ook zelf en vergelijkt het byte voor byte. De details, en wat het niet bewijst, staan in [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (in het Engels).

## Automatisch gecontroleerd

Hetzelfde script controleert de live app elk uur, en één keer per dag ook met `--rebuild`. De resultaten, en wat elke controle inhoudt, staan op de pagina [Status](/nl/status/).

## Wat dit niet kan bewijzen

- **Wat één persoon binnen Telegram te zien kreeg.** De eigenaar van de bot zou de app naar een ander adres kunnen laten verwijzen, voor iedereen of voor uitgekozen mensen. Een pagina op een ander adres heeft geen van je sleutels; om iets te bereiken, zou hij je opnieuw moeten laten instellen, en dat beëindigt je account op je oude apparaat op een manier die je merkt, en verandert je link.
- **Wat de server draait.** Het ontwerp hangt daar niet van af: een kwaadwillende server kan berichten tegenhouden of vertragen en de timing in de gaten houden, maar kan ze niet lezen of vervalsen, omdat de app elke sleutel zelf controleert. Aantonen welke code de server draait, is een latere stap (een geattesteerde enclave).
