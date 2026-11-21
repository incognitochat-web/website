---
title: "Security"
linkTitle: "Security"
description: "How to report a vulnerability in Incognito Chat."
updated: "2026-11-21"
---

Found a way to read someone's messages, link a sender to their account, or anything else that breaks what the app promises? Please tell us privately first.

## How to report

- **Preferred:** [report it privately on GitHub](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Only the maintainers see it.
- **Or by email:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Tell us what you found, how to reproduce it, and what an attacker could do with it.

## What to expect

- We'll answer within a week, and tell you what we'll do about it.
- We fix serious issues first, and publish what was wrong and how it was fixed once users are safe.
- We'll credit you, if you want.

## Please

- Test against your own accounts, or a copy you run yourself. The [code](https://github.com/{{< param "codeRepo" >}}) has everything needed to run one.
- Don't access other people's data, and don't disrupt the service for others.
- Give us a reasonable time to fix it before you publish.

We won't take legal action against research done this way.

## In scope

The app, the server, the protocol, the build and publishing pipeline, and this website. What the design already admits it can't protect is listed in the [security model](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md); new ways to exploit those limits are still welcome.

Our [`security.txt`](/.well-known/security.txt) has the same contacts in a standard form.
