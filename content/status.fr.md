---
title: "État"
linkTitle: "État"
description: "Des vérifications automatiques pour s’assurer que l’application en ligne correspond exactement au code publié : toutes les heures, et tous les jours avec une recompilation à partir du code source."
---

{{< status >}}

## Comment fonctionnent ces vérifications

Une [tâche planifiée](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) du dépôt public de ce site exécute [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), qui vient du dépôt de code de l’application, sur l’application en ligne. Chaque journal est public : ouvrez-en un pour voir chaque vérification et chaque fichier. Pour effectuer vous-même les mêmes vérifications, consultez [Vérifier l’application](/fr/verify/).
