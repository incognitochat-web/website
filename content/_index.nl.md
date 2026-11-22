---
title: "Incognito Chat"
lead: "Deel je persoonlijke link. Iedereen met die link kan je schrijven zonder dat jij weet wie het is, en jij kunt antwoorden. Berichten worden op je apparaat versleuteld, dus niemand anders kan ze lezen, ook niet degene die de server beheert."

preview:
  emoji: "🦊"
  sender: "K3F9"
  status: "Anoniem · via jouw link"
  messages:
    - side: in
      text: "Hoi! Ik vond je presentatie van gisteren geweldig. Mag ik je iets vragen?"
    - side: out
      text: "Natuurlijk, vraag maar 🙂"
    - side: in
      text: "Hoe ben je begonnen?"
  foot: "End-to-end versleuteld"

how:
  title: "Zo werkt het"
  steps:
    - title: "Maak je link"
      text: "Open de app in Telegram en maak je persoonlijke link. Vervang hem wanneer je wilt."
    - title: "Deel hem"
      text: "Iedereen met Telegram kan je via die link schrijven. Je ziet de ander als een label zoals **🦊 K3F9**, elke keer hetzelfde, en verder niets over die persoon."
    - title: "Praat"
      text: "Tekst, foto's, video's, bestanden, spraakberichten, stickers, reacties, bewerken en verwijderen aan beide kanten, zoals in elke chat."

features:
  title: "Privacy"
  intro: "Dit volgt uit hoe de app is gebouwd, dus het geldt ook als je ons niet vertrouwt."
  items:
    - title: "End-to-end versleuteld"
      text: "Elk bericht en elke bijlage wordt op je apparaat versleuteld. Alleen de twee mensen in een chat kunnen het lezen."
    - title: "Geen register van wie met wie praat"
      text: "Berichten gaan via willekeurige postvakken, nooit per account. Niets wat wordt opgeslagen, zegt wie naar wie schreef of wie een afzender is."
    - title: "Versturen zonder in te loggen"
      text: "Elk bericht verbruikt een anoniem token, zodat misbruik kan worden beperkt zonder te weten te komen wie de afzender is."
    - title: "Chats blijven op je apparaat"
      text: "De server bewaart versleutelde berichten alleen tot je apparaat ze heeft, hoogstens 30 dagen."
    - title: "Openbaar gebouwd"
      text: "Een openbare GitHub-workflow bouwt de app uit de openbare code, en GitHub Pages levert hem, niet onze servers. Elke build is reproduceerbaar en ondertekend in een openbaar logboek."
    - title: "Gratis, geen advertenties, geen trackers"
      text: "Vrije software onder de AGPL. Geen analysetools in de app of op deze site. Gefinancierd met donaties."

roadmap:
  title: "Plannen"
  items:
    - title: "Een server die bewijst wat hij draait"
      text: "We zijn van plan de server te verhuizen naar een geattesteerde enclave: een afgesloten deel van de machine waarvan iedereen de code kan controleren. Dan zou je ons niet meer op ons woord hoeven te geloven over wat de server doet, en zouden zelfs wij niet kunnen zien welk Telegram-account bij een link hoort."
    - title: "Cijfers die niemand kan vervalsen"
      text: "De pagina [Statistieken](stats/) toont per uur het aantal aangemaakte accounts en verstuurde berichten en de hoeveelheid media, en wat het draaien van de dienst kost, automatisch gepubliceerd en ondertekend. Zodra de enclave draait, gaat die ze zelf tellen en ondertekenen, zodat niemand ze kan vervalsen, ook wij niet."

verify:
  title: "Controleer het zelf"
  text: "De code van de app is openbaar, elke build is reproduceerbaar en ondertekend, en een script controleert of de app die Telegram opent precies die build is. De code van de server is ook openbaar, maar voor wat erop draait, moet je voorlopig vertrouwen op wat wij daarover bijhouden."
  button: "Zo verifieer je de app"
  secondary: "Laatste controles"
---
