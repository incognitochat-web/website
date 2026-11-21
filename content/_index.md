---
title: "Incognito Chat"
eyebrow: "Free software · End-to-end encrypted"
lead: "Share your personal link. Anyone with it can write to you without you knowing who they are, and you can reply. Messages are encrypted on your device, so nobody else can read them, including whoever runs the server."

preview:
  emoji: "🦊"
  sender: "K3F9"
  status: "Anonymous · through your link"
  messages:
    - side: in
      text: "Hi! I loved your talk yesterday. Can I ask you something?"
    - side: out
      text: "Of course, go ahead 🙂"
    - side: in
      text: "How did you get started?"
  foot: "End-to-end encrypted"

how:
  label: "How it works"
  title: "A link, a conversation, nothing else"
  steps:
    - title: "Get your link"
      text: "Open the app in Telegram and get your personal link. Replace it whenever you like."
    - title: "Share it"
      text: "Anyone with Telegram can write to you through it. They show up as a label like **🦊 K3F9**, the same each time, and nothing else about them."
    - title: "Talk"
      text: "Text, photos, videos, files, voice messages, stickers, reactions, edits and deleting for both sides, like any chat."

features:
  label: "Privacy by design"
  title: "Built so nobody else can read along"
  intro: "Not even us. The protections are in the design, not in a promise."
  items:
    - icon: lock
      title: "End-to-end encrypted"
      text: "Every message and attachment is encrypted on your device. Only the two people in a conversation can read it."
    - icon: route
      title: "No record of who talks to whom"
      text: "Messages travel through random mailboxes, never by account. Nothing stored says who wrote to whom, or who a sender is."
    - icon: ticket
      title: "No login to send"
      text: "Each message spends an anonymous token, so abuse can be limited without learning who sends."
    - icon: phone
      title: "Chats stay on your device"
      text: "The server only holds encrypted messages until your device has them, at most 30 days."
    - icon: check
      title: "Built in public"
      text: "A public GitHub workflow builds the app from the public code, and GitHub Pages serves it, not our servers. Every build is reproducible and signed in a public log."
    - icon: heart
      title: "Free, no ads, no trackers"
      text: "Free software under the AGPL. No analytics in the app or on this site. Funded by donations."

roadmap:
  label: "Roadmap"
  title: "Next: less to trust, even in us"
  items:
    - icon: server
      title: "A server that proves what it runs"
      text: "We plan to move the server into an attested enclave: a sealed part of the machine whose code anyone can check. Then you wouldn't have to take our word for what the server does, and not even we could tell which Telegram account owns a link."
    - icon: chart
      title: "Public numbers, every hour"
      text: "Accounts created, messages sent and media volume per hour, and what running the service costs, published automatically and signed. Once the enclave is live, it will count and sign them itself, so nobody can fake them."

verify:
  title: "Don't take our word for it"
  text: "The app's code is public, every build is reproducible and signed, and a script checks that the app Telegram opens is exactly that build. The server's code is public too, but for now you have to trust our records of what runs on it."
  button: "How to verify"
  secondary: "Official addresses"
---
