---
title: "Sécurité"
linkTitle: "Sécurité"
description: "Comment signaler une vulnérabilité dans Incognito Chat."
updated: "2026-11-21"
---

Vous avez trouvé un moyen de lire les messages de quelqu’un, de relier un expéditeur à son compte, ou quoi que ce soit d’autre qui va à l’encontre de ce que promet l’application ? Merci de nous le dire d’abord en privé.

## Comment signaler

- **De préférence :** [signalez-le en privé sur GitHub](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Seuls les mainteneurs le voient.
- **Ou par e-mail :** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Dites-nous ce que vous avez trouvé, comment le reproduire et ce qu’un attaquant pourrait en faire.

## À quoi vous attendre

- Nous vous répondrons sous une semaine, et vous dirons ce que nous comptons faire.
- Nous corrigeons d’abord les problèmes graves, et une fois les utilisateurs en sécurité, nous publions ce qui n’allait pas et comment cela a été corrigé.
- Nous vous citerons, si vous le souhaitez.

## Ce que nous vous demandons

- Faites vos tests sur vos propres comptes, ou sur une copie que vous faites tourner vous-même. Le [code](https://github.com/{{< param "codeRepo" >}}) contient tout le nécessaire pour en faire tourner une.
- N’accédez pas aux données d’autres personnes, et ne perturbez pas le service pour les autres.
- Laissez-nous un délai raisonnable pour corriger le problème avant de le rendre public.

Nous n’engagerons pas de poursuites judiciaires contre les recherches menées de cette façon.

## Périmètre

L’application, le serveur, le protocole, la chaîne de compilation et de publication, et ce site web. Ce que la conception reconnaît déjà ne pas pouvoir protéger est listé dans le [modèle de sécurité](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (en anglais) ; les nouvelles façons d’exploiter ces limites restent les bienvenues.

Notre fichier [`security.txt`](/.well-known/security.txt) donne les mêmes contacts sous une forme standard.
