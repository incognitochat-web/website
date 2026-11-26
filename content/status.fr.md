---
title: "État"
linkTitle: "État"
description: "Des vérifications automatiques pour s’assurer que l’application en ligne correspond exactement au code publié, toutes les heures et tous les jours avec une recompilation à partir du code source, et que le bot l’ouvre."
---

{{< status >}}

## Comment fonctionnent ces vérifications

Deux tâches planifiées du dépôt public de ce site exécutent les vérifications de [Vérifier l’application](/fr/verify/), où vous pouvez aussi les effectuer vous-même : [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) vérifie l’application en ligne toutes les heures, et la recompile aussi une fois par jour à partir du code source ; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) vérifie toutes les heures ce que le bot ouvre, avec un compte Telegram créé à cet effet. Le journal de chaque exécution est public. La vérification du bot n’indique que ce qui a été montré à ce compte à ce moment-là : pour vérifier ce qui vous est montré, [lancez-la avec votre propre compte](/fr/verify/#bot-check).
