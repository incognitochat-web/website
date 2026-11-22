---
title: "Vérifier l’application"
linkTitle: "Vérifier"
description: "Comment n’importe qui peut vérifier que l’application ouverte par Telegram correspond exactement au code publié."
updated: "2026-11-21"
---

Le chiffrement ne vous protège que si l’application que vous utilisez est bien le code publié. Dans Telegram, rien n’empêche la personne qui gère le bot de le faire pointer vers une autre page : l’application est donc publiée d’une manière que chacun peut vérifier.

## Comment l’application est publiée

- **Compilée au grand jour.** Un workflow public dans [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) compile une version publiée du [code](https://github.com/{{< param "codeRepo" >}}), sans aucun autre code dans ce dépôt.
- **Reproductible.** Une même version donne toujours des fichiers identiques octet pour octet : chacun peut donc la recompiler et comparer.
- **Signée dans un journal public.** Chaque fichier, ainsi qu’un `manifest.json` qui liste le SHA-256 de chacun d’eux, est signé avec [Sigstore](https://www.sigstore.dev/) par ce workflow. Les signatures sont dans un journal de transparence public, qui ne peut pas être réécrit discrètement.
- **Une seule adresse, rien d’autre dessus.** L’application n’est servie que depuis `{{< param "appOrigin" >}}`, et rien d’autre n’y est jamais servi : une page à la même adresse pourrait atteindre les clés sur votre appareil.
- **Verrouillée.** L’application ne charge aucun code tiers, aucune mesure d’audience, et aucun code ni réglage venant du serveur.

## Vérifiez par vous-même

Depuis une copie locale du [code](https://github.com/{{< param "codeRepo" >}}), avec la CLI GitHub connectée à votre compte :

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Le script vérifie que chaque fichier servi est exactement ce que le workflow relu et non modifié a compilé à partir d’une version publiée sur `main`, que c’est la même exécution de ce workflow qui l’a déployé, et qu’aucun autre site ne partage l’adresse de l’application. Avec `--rebuild`, il compile aussi lui-même cette version et compare octet pour octet. Les détails, et ce que cela ne prouve pas, sont dans [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (en anglais).

## Vérifié automatiquement

Le même script vérifie l’application en ligne toutes les heures, et une fois par jour avec `--rebuild`. Les résultats, et ce que couvre chaque vérification, sont sur la page [État](/fr/status/).

## Ce que cela ne peut pas prouver

- **Ce qui a été montré à une personne donnée dans Telegram.** Le propriétaire du bot pourrait faire pointer l’application vers une autre adresse, pour tout le monde ou pour des personnes choisies. Une page à une autre adresse n’a aucune de vos clés ; pour arriver à ses fins, elle devrait vous faire reconfigurer l’application, ce qui met fin à votre compte sur votre ancien appareil de façon bien visible et change votre lien.
- **Ce que le serveur exécute.** La conception n’en dépend pas : un serveur malveillant peut supprimer ou retarder des messages et observer à quels moments ils passent, mais il ne peut ni les lire ni les falsifier, car l’application vérifie elle-même chaque clé. Prouver le code du serveur est une étape future (une enclave attestée).
