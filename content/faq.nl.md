---
title: "Vragen en antwoorden"
linkTitle: "Vragen"
description: "Korte antwoorden over wat Incognito Chat beschermt, wat het niet kan beschermen en hoe je het gebruikt."
updated: "2026-11-22"
---

## Privacy

### Komt de persoon aan wie ik schrijf te weten wie ik ben?

Nee. De ander ziet een label zoals **🦊 K3F9**, steeds hetzelfde als je via de link van die persoon schrijft, en verder niets over jou: niet je naam, gebruikersnaam of telefoonnummer. Foto's verliezen verborgen gegevens zoals de locatie voordat ze worden verstuurd, en video's het grootste deel daarvan. Alles wat je met **Bestand** stuurt, en ook muziek en GIF's, gaat zoals het is, met de bestandsnaam en alles wat erin zit.

### Kunnen jullie mijn berichten lezen?

Nee. Berichten en bijlagen worden op je apparaat versleuteld, en alleen de twee mensen in een chat kunnen ze lezen. De server bewaart berichten, versleuteld, alleen tot het andere apparaat ze heeft, en bijlagen tot ze worden verwijderd: in beide gevallen hoogstens 30 dagen.

### Weet de server wie naar wie schrijft?

Niets wat hij opslaat, zegt dat: berichten gaan via willekeurige postvakken, niet per account, en worden verstuurd zonder in te loggen. Maar wie de servers beheert, zou het verkeer live kunnen volgen. Zie [Iemand die live meekijkt](#live) hieronder.

### Kunnen jullie zien welk Telegram-account bij een link hoort?

Op dit moment wel, als we ervoor zouden kiezen om te kijken. De server bewaart een versluierde vorm van het Telegram-ID van elk account, en wie de sleutels van de server heeft, kan het ID daaruit afleiden. Het laat niemand zien wie er naar jou schrijft, want berichten worden verstuurd zonder in te loggen. De server naar een enclave verhuizen, [een van onze plannen](/nl/#roadmap), zou dit ook voor ons onmogelijk maken.

### Wat ziet Telegram?

Dat je de bot gebruikt, welke links je opent en wanneer er meldingen “Nieuw bericht” worden verstuurd. Niet wat je schrijft: berichten gaan versleuteld via onze server, nooit via Telegram-chats.

## Wat het niet kan beschermen

### Een nagemaakte pagina in Telegram

Wie de bot beheert, bepaalt welke pagina Telegram opent, en Telegram biedt geen manier om dat vast te zetten. Een pagina die vanaf een ander adres dan het [officiële adres](/nl/official/) wordt geladen, heeft geen van je sleutels, dus kan hij je eerdere berichten niet lezen, maar wat je erin typt, is niet veilig. Vraagt de app je ooit om opnieuw in te stellen terwijl je daar niet zelf voor hebt gekozen, doe het dan niet. Iedereen kan [controleren](/nl/verify/) of het officiële adres precies de gepubliceerde code levert.

### Iemand die live meekijkt {#live}

Wie de servers beheert, of Amazon, waar ze draaien, zou verzoeken live kunnen volgen en mensen aan elkaar kunnen koppelen via timing en IP-adres: een bericht dat binnenkomt, dan een melding, dan een antwoord of een “Gelezen”. Telegram zou mensen ook via timing aan elkaar kunnen koppelen. Een kopie van de opgeslagen gegevens laat dit niet zien, maar met de sleutels van de server is een deel ervan te zien in gegevens die ongeveer een dag worden bewaard. Ook met de enclave zouden timing en IP-adressen nog steeds te zien zijn.

### Je eigen apparaat

De app draait binnen Telegram, op je telefoon of computer. Iedereen die je ontgrendelde apparaat kan gebruiken, of malware erop, kan je chats lezen, zoals bij elke app. De Telegram-app zelf zou dat ook kunnen. Met een kopie van de opslag van de app op je apparaat, zoals een forensische kopie van je telefoon, kan iemand je chats openen en je account gebruiken.

### Screenshots

De persoon aan wie je schrijft, kan altijd kopiëren of fotograferen wat je stuurt. Als je een bericht aan beide kanten verwijdert, wordt de app van de ander gevraagd het weg te halen, maar een kopie die de ander heeft gemaakt, valt daar niet onder.

## Gebruik

### Moet ik me registreren?

Nee. Om via iemands link te schrijven, is je Telegram-account genoeg: open de link en schrijf. Voor een eigen link heb je voorlopig een uitnodiging nodig.

### Wat als iemand me lastigvalt?

Blokkeer die persoon: die wordt niet ingelicht, en niets wat die stuurt, komt nog aan. Wie een nieuw account instelt, verschijnt onder een nieuw label, dus misschien moet je die persoon opnieuw blokkeren. Je kunt ook op elk moment je link vervangen; de oude werkt dan meteen niet meer.

### Kan ik verwijderen wat ik heb gestuurd?

Ja. Als je een bericht verwijdert, wordt het standaard aan beide kanten verwijderd, gelezen of niet. Je kunt ook een hele chat aan beide kanten verwijderen.

### Kan ik het op een andere telefoon of computer gebruiken?

Op één apparaat tegelijk. Als je de app op een ander apparaat instelt, vervangt dat je account: je krijgt een nieuwe link, die mensen nodig hebben om je te bereiken, en je oude chats blijven op het oude apparaat staan, waar je ze alleen kunt lezen. Er wordt niets overgezet en er wordt geen back-up gemaakt, dus als je je telefoon kwijtraakt, zijn de chats erop weg. Stel de app dan opnieuw in op een nieuwe: dat beëindigt het oude account meteen.

### Hoe verwijder ik mijn account?

Tik op het tabblad **Mijn link** op **Account verwijderen**. Zolang de app open blijft, verwijdert de server binnen enkele minuten wat hij voor je bewaart, en daarna verwijdert de app je chats en sleutels van dit apparaat. Bijlagen die je hebt gestuurd, kan de ander nog ophalen tot ze verlopen, binnen 30 dagen.

### Hoe lang wordt wat bewaard?

Op de server: versleutelde berichten tot je apparaat ze heeft, bijlagen tot ze worden verwijderd, allebei hoogstens 30 dagen. Je account (met onder meer je link, het versluierde Telegram-ID en de maand waarin je de app voor het laatst opende) blijft bestaan tot je het verwijdert, of tot de app 12 maanden niet is geopend. Op je apparaat: je chats, tot je ze verwijdert. Hoe lang bijlagen blijven (altijd, een maand of een week), kies je in **Data en opslag**.

## Het project

### Is het gratis? Wie betaalt het?

Het is gratis, zonder advertenties en zonder trackers, en wordt betaald met donaties. Incognito Chat is vrije software onder de AGPL en wordt openbaar gebouwd: [de code](https://github.com/{{< param "codeRepo" >}}) en [deze site](https://github.com/{{< param "siteRepo" >}}) staan op GitHub.

### Hoe kan ik dit allemaal controleren?

Je hoeft ons niet op ons woord te geloven. De pagina [Verifiëren](/nl/verify/) laat zien hoe iedereen de app kan controleren, en [Status](/nl/status/) toont de laatste automatische controles. De details staan in het [beveiligingsmodel](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) en in de lijst van [wat de software opslaat](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/data.md) (allebei in het Engels).

### Ik heb een beveiligingsprobleem gevonden

Laat het ons eerst privé weten: zie [Beveiliging](/nl/security/).
