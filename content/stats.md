---
title: "Statistics"
linkTitle: "Stats"
description: "How much the service is used, hour by hour, and what it costs to run. Real numbers, small ones included."
---

{{< stats >}}

## What's counted

- **Accounts set up**: successful setups, setting up again on a new device and a setup retried after a lost answer included.
- **Messages sent**: the messages people write, with text, attachments or stickers. Not seen receipts, reactions, edits, deletes or key updates, which the app marks as quiet. Sends to an ended link count too, since the server answers them the same on purpose. A modified app could mark a message quiet, or send more, as far as its tokens allow.
- **Media**: the size of the attachments paid for, padded as the app pads every file (a power of two up to 1 MiB, then whole MiB), so a little above their real size. It counts uploads paid for, not finished ones, and every kind of file together: the server can't tell a photo from a voice message.
- **Costs**: what AWS charges to run the service each day, before any credits: production by service, the four biggest by name, and the test environment as one total. AWS revises the latest days for a while, and this month's numbers are its estimates.

Counts and sums only: nothing here, or where the counts come from, says who did what.

## Where the numbers come from

- The app's server counts once a minute, and AWS (CloudWatch) adds the counts up by the hour. A [scheduled job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/stats.yml) in this site's public repository reads them every hour, and the costs once a day, with a role that can read counts and costs and nothing else.
- An hour's counts are dated by when the server wrote them, which on a quiet server can be some minutes later, so an hour can hold a few counts from the one before. Each run reads the last 48 hours again, so a run that's late or missed leaves no gap.
- The job keeps every number it reads in the repository's [`data` branch](https://github.com/{{< param "siteRepo" >}}/tree/data/stats), so their history is public, and signs each file it writes with Sigstore:

  ```shell
  gh attestation verify <file> --repo {{< param "siteRepo" >}} \
    --cert-identity https://github.com/{{< param "siteRepo" >}}/.github/workflows/stats.yml@refs/heads/main
  ```

- That shows a number came through this public job unchanged. It can't show that what AWS holds is true: whoever runs the AWS account could change it. Once the server runs in an attested enclave (see the roadmap on the [home page](/)), it will count and sign the numbers itself.
