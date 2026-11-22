---
title: "Adresses officielles"
linkTitle: "Adresses officielles"
description: "Le seul vrai bot, l’adresse de l’application et l’endroit où se trouve le code. Tout le reste, ce n’est pas nous."
updated: "2026-11-23"
---

Voici les seules adresses officielles d’Incognito Chat. **Tout le reste, ce n’est pas nous**, même si le nom y ressemble beaucoup : vous ne pouvez pas confier vos messages aux copies du bot ou de l’application.

{{< official >}}

## Comment les reconnaître

- **Le nom d’utilisateur du bot est exactement `@{{< param "botUsername" >}}`.** Vérifiez chaque lettre : les noms qui lui ressemblent sont la ruse la plus courante.
- **L’application est toujours servie depuis `{{< param "appOrigin" >}}`.** Vos clés sont liées à cette adresse : une page servie depuis n’importe où ailleurs démarre donc sans elles. Elle ne peut pas lire vos anciens messages, et elle serait obligée de vous demander de reconfigurer l’application.
- **Le bot n’envoie qu’un court message de bienvenue et des notifications « Nouveau message ».** Une notification ne dit jamais qui a écrit ni quoi, et le bot ne vous demande jamais de reconfigurer l’application ni d’ouvrir un autre lien.
- **Il n’est jamais nécessaire de reconfigurer l’application**, sauf si vous avez choisi de recommencer. Si l’application vous demande de la configurer alors que vous ne l’avez pas choisi, ne le faites pas : vous n’êtes pas dans la vraie application. Fermez l’application, vérifiez que vous l’avez ouverte depuis `@{{< param "botUsername" >}}` et, si c’est le cas, prévenez-nous à [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

## Où se trouve cette liste

Cette page est générée à partir du [dépôt public du site](https://github.com/{{< param "siteRepo" >}}) : chaque modification qui y est faite a donc une date publique.
