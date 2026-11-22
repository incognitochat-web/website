---
title: "Status"
linkTitle: "Status"
description: "Automatic checks that the live app is exactly the published code: every hour, and every day with a rebuild from source."
---

{{< status >}}

## How these checks work

A [scheduled job](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) in this site's public repository runs [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), from the app's code repository, against the live app. Every log is public: open one to see each check and each file. To run the same checks yourself, see [Verify the app](/verify/).
