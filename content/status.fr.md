---
title: "État"
linkTitle: "État"
description: "Des vérifications automatiques pour s’assurer que l’application en ligne correspond exactement au code publié, toutes les heures et tous les jours avec une recompilation à partir du code source, et que le bot l’ouvre."
---

{{< status >}}

## Comment fonctionnent ces vérifications

Une [tâche planifiée](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) du dépôt public de ce site exécute [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), qui vient du dépôt de code de l’application, sur l’application en ligne. Chaque journal est public : ouvrez-en un pour voir chaque vérification et chaque fichier. Pour effectuer vous-même les mêmes vérifications, consultez [Vérifier l’application](/fr/verify/).

Une autre [tâche planifiée](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) exécute toutes les heures [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), qui vient lui aussi du dépôt de code de l’application, avec un compte Telegram créé à cet effet. Le script demande à Telegram ce que les liens de l’application (`t.me/{{< param "botUsername" >}}?startapp`) et le bouton de menu du bot ouvrent, et envoie /start au bot pour lire le bouton dans sa réponse, le tout sans ouvrir l’application. Cela montre ce qui a été servi à ce compte à ce moment-là : un remplacement visant seulement des personnes choisies, ou un remplacement de courte durée entre deux vérifications, n’apparaîtrait pas ici. Pour vérifier ce qui vous est servi, exécutez le même script avec votre propre compte ([comment faire, en anglais](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
