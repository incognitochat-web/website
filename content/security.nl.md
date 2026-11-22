---
title: "Beveiliging"
linkTitle: "Beveiliging"
description: "Zo meld je een kwetsbaarheid in Incognito Chat."
updated: "2026-11-21"
---

Heb je een manier gevonden om iemands berichten te lezen, een afzender aan diens account te koppelen, of iets anders dat breekt wat de app belooft? Laat het ons dan eerst privé weten.

## Zo meld je het

- **Liefst:** [meld het privé op GitHub](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Alleen de beheerders van het project zien het.
- **Of per e-mail:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Vertel ons wat je hebt gevonden, hoe we het kunnen reproduceren en wat een aanvaller ermee zou kunnen doen.

## Wat je kunt verwachten

- We antwoorden binnen een week en vertellen je wat we eraan gaan doen.
- Ernstige problemen lossen we eerst op, en zodra gebruikers veilig zijn, publiceren we wat er mis was en hoe het is opgelost.
- Als je wilt, vermelden we je naam.

## Wat we van je vragen

- Test met je eigen accounts, of met een kopie die je zelf draait. De [code](https://github.com/{{< param "codeRepo" >}}) bevat alles wat je nodig hebt om er een te draaien.
- Blijf van de gegevens van anderen af, en verstoor de dienst niet voor anderen.
- Geef ons redelijk de tijd om het op te lossen voordat je iets publiceert.

We ondernemen geen juridische stappen tegen onderzoek dat op deze manier wordt gedaan.

## Wat eronder valt

De app, de server, het protocol, de build- en publicatiepijplijn, en deze website. Wat het ontwerp al erkent niet te kunnen beschermen, staat in het [beveiligingsmodel](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (in het Engels); nieuwe manieren om die beperkingen te misbruiken zijn nog steeds welkom.

Onze [`security.txt`](/.well-known/security.txt) bevat dezelfde contactgegevens in een standaardvorm.
