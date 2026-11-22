---
title: "Statistieken"
linkTitle: "Statistieken"
description: "Hoeveel de dienst wordt gebruikt, per uur, en wat het kost om hem te draaien. Echte cijfers, ook als ze klein zijn."
---

{{< stats >}}

## Wat er wordt geteld

- **Ingestelde accounts**: elke keer dat het instellen is gelukt, ook opnieuw instellen op een nieuw apparaat en een nieuwe poging nadat een antwoord verloren ging.
- **Verstuurde berichten**: de berichten die mensen schrijven, met tekst, bijlagen of stickers. Leesbevestigingen, reacties, bewerkingen, verwijderingen en sleutelupdates tellen niet mee: die markeert de app als stil (zonder melding). Berichten naar een link die niet meer werkt, tellen ook mee, omdat de server daar met opzet net zo op antwoordt. Een aangepaste app zou een bericht als stil kunnen markeren, of meer kunnen versturen, voor zover zijn tokens dat toelaten.
- **Media**: de grootte van de betaalde bijlagen, opgevuld zoals de app elk bestand opvult (tot een macht van twee, tot en met 1 MiB; daarboven tot hele MiB), dus iets groter dan hun echte grootte. Het telt betaalde uploads, niet voltooide, en alle soorten bestanden samen: de server kan een foto niet onderscheiden van een spraakbericht.
- **Kosten**: wat AWS elke dag rekent voor het draaien van de dienst, vóór aftrek van eventuele credits: productie per dienst, de vier grootste bij naam, en de testomgeving als één totaal. AWS past de laatste dagen nog een tijdje aan, en de cijfers van deze maand zijn schattingen van AWS.

Alleen aantallen en totalen: niets hier, of op de plek waar de aantallen vandaan komen, zegt wie wat deed.

## Waar de cijfers vandaan komen

- De server van de app telt één keer per minuut, en AWS (CloudWatch) telt de aantallen per uur op. Een [geplande taak](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/stats.yml) in de openbare repository van deze site leest ze elk uur, en de kosten één keer per dag, met een rol die alleen meetgegevens en kosten kan lezen.
- De aantallen van een uur krijgen het tijdstip waarop de server ze wegschreef, en op een rustige server kan dat veel later zijn: hij schrijft de aantallen van een minuut weg bij zijn volgende verzoek, of wanneer hij stopt. Een uur kan dus aantallen van eerdere uren bevatten. Elke run leest de laatste 7 dagen opnieuw, dus runs die tot een week te laat zijn of zijn overgeslagen, laten geen gat achter.
- De taak bewaart elk cijfer dat hij leest in de [branch `data`](https://github.com/{{< param "siteRepo" >}}/tree/data/stats) van de repository, zodat de geschiedenis ervan openbaar is, en ondertekent elk bestand dat hij schrijft met Sigstore:

  ```shell
  gh attestation verify <file> --repo {{< param "siteRepo" >}} \
    --cert-identity https://github.com/{{< param "siteRepo" >}}/.github/workflows/stats.yml@refs/heads/main
  ```

- Dat laat zien dat een cijfer ongewijzigd door deze openbare taak is gekomen. Het kan niet laten zien dat wat AWS bewaart klopt: wie het AWS-account beheert, zou dat kunnen veranderen. Zodra de server in een geattesteerde enclave draait (zie de plannen op de [startpagina](/nl/)), gaat hij de cijfers zelf tellen en ondertekenen.
