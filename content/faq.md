---
title: "Questions and answers"
linkTitle: "FAQ"
description: "Short answers about what Incognito Chat protects, what it can't, and how to use it."
updated: "2026-11-22"
---

## Privacy

### Does the person I write to find out who I am?

No. They see a label like **🦊 K3F9**, the same each time you write through their link, and nothing else about you: not your name, username or phone number.

### Can you read my messages?

No. Messages and attachments are encrypted on your device, and only the two people in a conversation can open them. The server only holds them, encrypted, until the other device has them, at most 30 days.

### Does the server know who writes to whom?

Nothing it stores says so: messages travel through random mailboxes, not by account, and sending needs no login. But whoever runs the servers could watch traffic as it happens. See [Someone watching live](#live) below.

### Can you tell which Telegram account owns a link?

Today, yes, if we chose to look. The server keeps a scrambled form of each account's Telegram ID, and whoever holds the server's keys can work the ID out from it. It doesn't tell anyone who writes to you, since senders don't log in. Moving the server into an enclave, [on the roadmap](/#roadmap), would take this away from us too.

### What does Telegram see?

That you use the bot, which links you open, and when "New message" notices go out. Not what you write: messages travel encrypted through our server, never through Telegram chats.

## What it can't protect

### A fake page inside Telegram

Whoever controls the bot decides which page Telegram opens, and Telegram offers no way to lock it. A page served from anywhere but the [official address](/official/) has none of your keys, so it can't read your past messages, but what you type into it isn't safe. If the app ever asks you to set up again when you didn't choose to, don't. Anyone can [check](/verify/) that the official address serves exactly the published code.

### Someone watching live {#live}

Whoever runs the servers, or Amazon, who hosts them, could watch requests as they happen and link people by timing and IP address: a message arriving, then a reply. Stored data doesn't show this; only live watching does. Even with the enclave, timing and IP addresses would still show.

### Your own device

The app runs inside Telegram, on your phone or computer. Anyone who can use your unlocked device, or malware on it, can read your chats, as with any app. The Telegram app itself could too.

### Screenshots

The person you write to can always copy or photograph what you send. Deleting a message for both sides removes it from their device, but not from a copy they made.

## Using it

### Do I need to sign up?

No. Open [@{{< param "botUsername" >}}](https://t.me/{{< param "botUsername" >}}) in Telegram and set up: your Telegram account is enough. Nothing else is asked for.

### What if someone bothers me?

Block them: they aren't told, and nothing they send arrives. You can also replace your link at any time; the old one stops working at once.

### Can I delete what I sent?

Yes. Deleting a message removes it for both sides by default, read or not. You can delete a whole chat for both sides too.

### Can I use it on another phone or computer?

One device at a time. Setting up on another device replaces your account: you get a new link, and your chats stay on the old device; they don't move. If you lose your phone, set up again on a new one: that ends the old account at once.

### How long is anything kept?

On the server: encrypted messages until your device has them, attachments until they're deleted, at most 30 days for both. An account whose app isn't opened for 12 months is deleted. On your device: your chats, until you delete them. You choose how long attachments stay (forever, a month or a week) in Data and storage.

## The project

### Is it free? Who pays for it?

It's free, with no ads and no trackers, and paid for by donations. Incognito Chat is free software under the AGPL, built in public: [the code](https://github.com/{{< param "codeRepo" >}}) and [this site](https://github.com/{{< param "siteRepo" >}}) are on GitHub.

### How can I check any of this?

You don't have to take our word for it. The [Verify](/verify/) page shows how anyone can check the app, and [Status](/status/) shows the latest automatic checks. The details are in the [security model](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) and the list of [what the software stores](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/data.md).

### I found a security problem

Please tell us privately first: see [Security](/security/).
