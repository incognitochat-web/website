# The usage and costs numbers: what's counted, and where they come from

How the numbers on [incognitochat.me/stats](https://incognitochat.me/stats/)
(usage) and the costs on [incognitochat.me/donate](https://incognitochat.me/donate/#costs)
are counted and collected, and how to check them. (The donations on that
page come from Open Collective, which lists each one.) How the pipeline is built
is in the [README](../README.md#statistics).

## What's counted

- **Accounts set up**: successful setups, setting up again on a new device and
  a setup retried after a lost answer included.
- **Messages sent**: the messages people write, with text, attachments or
  stickers. Not seen receipts, reactions, edits, deletes or key updates, which
  the app marks as quiet. Sends to an ended link count too, since the server
  answers them the same on purpose. A modified app could mark a message quiet,
  or send more, as far as its tokens allow.
- **Media**: the size of the attachments paid for, padded as the app pads
  every file (a power of two up to 1 MiB, then whole MiB), so a little above
  their real size. It counts uploads paid for, not finished ones, and every
  kind of file together: the server can't tell a photo from a voice message.
- **Costs**: what AWS charges to run the service each day, before any credits:
  production by service (each month's four biggest by name, the rest as
  Other), and the test environment as one total. AWS revises the latest days
  for a while, and this month's numbers are its estimates.

Counts and sums only: nothing on the page, or where the counts come from, says
who did what.

Each count starts at the first whole hour production counted it
(`params.statsCountedFrom` in [`hugo.toml`](../hugo.toml)): accounts from
2026-11-18 23:00 UTC, the first whole hour after v2.4.0 added the counter
(deployed at 22:14), and messages and media from 2026-11-22 03:00 UTC, after
v2.7.0. Earlier days show "—", and the page notes
the start in the month it falls in.

## Where the numbers come from

- The app's server counts once a minute, and AWS (CloudWatch) adds the counts
  up by the hour. A [scheduled job](../.github/workflows/stats.yml) in this
  public repository reads them every hour, and the costs once a day, with a role that
  can only read metrics and costs.
- An hour's counts are dated by when the server wrote them, which can be much
  later on a quiet server: it writes a minute's counts with its next request,
  or when it shuts down. So an hour can hold counts from earlier ones. Each
  run reads the last 7 days again, so runs late or missed for up to a week
  leave no gap.
- The job keeps every number it reads in this repository's
  [`data` branch](https://github.com/incognitochat-web/website/tree/data/stats),
  so their history is public, and signs each file it writes with Sigstore:

  ```shell
  gh attestation verify <file> --repo incognitochat-web/website \
    --cert-identity https://github.com/incognitochat-web/website/.github/workflows/stats.yml@refs/heads/main
  ```

- That shows a number came through this public job unchanged. It can't show
  that what AWS holds is true: whoever runs the AWS account could change it.
  Once the server runs in an attested enclave (see the roadmap on the
  [home page](https://incognitochat.me/)), it will count and sign the
  numbers itself.
