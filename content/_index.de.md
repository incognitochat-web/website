---
title: "Incognito Chat"
lead: "Teile deinen persönlichen Link. Alle, die ihn haben, können dir schreiben, ohne dass du weißt, wer sie sind, und du kannst antworten. Nachrichten werden auf deinem Gerät verschlüsselt, daher kann niemand sonst sie lesen, auch nicht, wer den Server betreibt."

preview:
  emoji: "🦊"
  sender: "K3F9"
  status: "Anonym · über deinen Link"
  messages:
    - side: in
      text: "Hi! Dein Vortrag gestern war toll. Darf ich dich etwas fragen?"
    - side: out
      text: "Klar, frag ruhig 🙂"
    - side: in
      text: "Wie hast du angefangen?"
  foot: "Ende-zu-Ende-verschlüsselt"

how:
  title: "So funktioniert’s"
  steps:
    - title: "Hol dir deinen Link"
      text: "Öffne die App in Telegram und hol dir deinen persönlichen Link. Du kannst ihn jederzeit gegen einen neuen tauschen."
    - title: "Teile ihn"
      text: "Alle mit Telegram können dir darüber schreiben. Du siehst sie nur unter einem Namen wie **🦊 K3F9**, jedes Mal demselben, und sonst nichts über sie."
    - title: "Chatte"
      text: "Text, Bilder, Videos, Dateien, Sprachnachrichten, Sticker, Reaktionen, Bearbeiten und Löschen auf beiden Seiten, wie in jedem Chat."

features:
  title: "Privatsphäre"
  intro: "Das folgt aus dem Aufbau der App und gilt deshalb auch, wenn du uns nicht vertraust."
  items:
    - title: "Ende-zu-Ende-verschlüsselt"
      text: "Jede Nachricht und jeder Anhang wird auf deinem Gerät verschlüsselt. Nur die beiden Personen in einem Chat können sie lesen."
    - title: "Keine Aufzeichnung, wer mit wem schreibt"
      text: "Nachrichten laufen über zufällige Postfächer, nie über Konten. Nichts, was gespeichert wird, hält fest, wer wem geschrieben hat oder wer ein Absender ist."
    - title: "Senden ohne Anmeldung"
      text: "Jede Nachricht verbraucht ein anonymes Token. So lässt sich Missbrauch begrenzen, ohne zu erfahren, wer sendet."
    - title: "Chats bleiben auf deinem Gerät"
      text: "Der Server bewahrt verschlüsselte Nachrichten nur auf, bis dein Gerät sie hat, höchstens 30 Tage lang."
    - title: "Öffentlich gebaut"
      text: "Ein öffentlicher GitHub-Workflow baut die App aus dem öffentlichen Code, und GitHub Pages liefert sie aus, nicht unsere Server. Jeder Build ist reproduzierbar und signiert, und die Signaturen stehen in einem öffentlichen Protokoll."
    - title: "Kostenlos, ohne Werbung, ohne Tracker"
      text: "Freie Software unter der AGPL. Keine Webanalyse in der App oder auf dieser Website. Spenden helfen, die Kosten zu decken."

roadmap:
  title: "Pläne"
  items:
    - title: "Ein Server, der beweist, was auf ihm läuft"
      text: "Wir planen, den Server in eine attestierte Enklave zu verlegen: einen abgeschotteten Teil des Rechners, dessen Code jeder prüfen kann. Dann müsstest du uns nicht mehr einfach glauben, was der Server tut, und nicht einmal wir könnten erkennen, welchem Telegram-Konto ein Link gehört."
    - title: "Zahlen, die niemand fälschen kann"
      text: "Die Seite [Statistik](stats/) zeigt pro Stunde neue Konten, gesendete Nachrichten und die Menge an Medien, die Seite [Spenden und Kosten](donate/#costs), was der Betrieb des Dienstes kostet, alles automatisch veröffentlicht und signiert. Sobald die Enklave läuft, wird sie die Zahlen selbst zählen und signieren, sodass niemand sie fälschen kann, nicht einmal wir."

verify:
  title: "Prüf es selbst"
  text: "Der Code der App ist öffentlich, jeder Build ist reproduzierbar und signiert, und ein Skript prüft, ob die App, die Telegram öffnet, genau dieser Build ist. Auch der Code des Servers ist öffentlich, aber bei dem, was auf ihm läuft, musst du dich vorerst auf unsere Aufzeichnungen verlassen."
  button: "So prüfst du die App"
  secondary: "Neueste Prüfungen"
---
