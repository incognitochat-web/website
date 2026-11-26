---
title: "Questions et réponses"
linkTitle: "Questions"
description: "Des réponses courtes sur ce qu’Incognito Chat protège, ce qu’il ne peut pas protéger et comment l’utiliser."
updated: "2026-11-25"
---

## Confidentialité

### La personne à qui j’écris apprend-elle qui je suis ?

Non. Elle voit un nom comme **🦊 K3F9**, le même chaque fois que vous écrivez via son lien, et rien d’autre à votre sujet : ni votre nom, ni votre nom d’utilisateur, ni votre numéro de téléphone. Les photos et les vidéos envoyées comme photos ou vidéos perdent leur nom de fichier et leurs informations cachées, comme la localisation (pour les vidéos, la plupart de ces informations). Tout ce qui est envoyé comme fichier (avec **Fichier**, ou avec **Compresser l’image** ou **Envoyer comme vidéo** désactivé), ainsi que la musique, part tel quel, avec son nom de fichier et tout ce qu’il contient. Les GIF partent sans leur nom de fichier, mais sinon tels quels.

### Pouvez-vous lire mes messages ?

Non. Les messages et les pièces jointes sont chiffrés sur votre appareil, et seules les deux personnes d’un échange peuvent les lire. Le serveur ne conserve les messages, chiffrés, que jusqu’à ce que l’autre appareil les ait reçus, et les pièces jointes jusqu’à ce qu’elles soient supprimées : 30 jours au maximum dans les deux cas.

### Le serveur sait-il qui écrit à qui ?

Rien de ce qu’il stocke ne l’indique : les messages transitent par des boîtes de réception aléatoires, pas par compte, et sont envoyés sans connexion à un compte. Mais ceux qui gèrent les serveurs pourraient observer le trafic en direct. Voir [Quelqu’un qui observe en direct](#live), plus bas.

### Pouvez-vous savoir à quel compte Telegram appartient un lien ?

Aujourd’hui, oui, si nous décidions de regarder. Le serveur conserve une forme brouillée de l’identifiant Telegram de chaque compte, et quiconque détient les clés du serveur peut en retrouver l’identifiant. Pour la plupart des liens, cela compte peu : un lien est fait pour être publié ou envoyé, donc la personne qui l’a sait généralement déjà à qui il appartient. Et savoir à qui il appartient n’apprend à personne qui vous écrit, puisque les messages sont envoyés sans connexion à un compte. Déplacer le serveur dans une enclave, comme le prévoit notre [feuille de route](/fr/#roadmap), nous retirerait cette possibilité, à nous aussi.

### Que voit Telegram ?

Que vous utilisez le bot, quels liens vous ouvrez, et quand les notifications « Nouveau message » sont envoyées. Pas ce que vous écrivez : les messages transitent chiffrés par notre serveur, jamais par des discussions Telegram.

## Ce qu’Incognito Chat ne peut pas protéger

### Une fausse page dans Telegram

La personne qui contrôle le bot décide de la page qu’ouvre Telegram, et Telegram n’offre aucun moyen de la verrouiller. Une page servie depuis une autre adresse que l’[adresse officielle](/fr/official/) n’a aucune de vos clés : elle ne peut donc pas lire vos anciens messages, mais ce que vous y tapez n’est pas en sécurité. Si un jour l’application vous demande de la reconfigurer alors que vous ne l’avez pas choisi, ne le faites pas. N’importe qui peut [vérifier](/fr/verify/) que l’adresse officielle sert exactement le code publié.

### Quelqu’un qui observe en direct {#live}

Ceux qui gèrent les serveurs, ou Amazon, qui les héberge, pourraient observer les requêtes au moment où elles arrivent et relier des personnes entre elles en recoupant les horaires et les adresses IP : un message qui arrive, puis une notification, puis une réponse ou un « Vu ». Telegram pourrait aussi relier des personnes grâce aux horaires. Une copie des données stockées ne le montre pas, mais, avec les clés du serveur, des enregistrements conservés jusqu’à un jour, parfois quelques jours de plus, en montrent une partie. Même avec l’enclave, les horaires et les adresses IP resteraient visibles.

### Votre propre appareil

L’application fonctionne dans Telegram, sur votre téléphone ou votre ordinateur. Toute personne qui peut utiliser votre appareil déverrouillé, ou un logiciel malveillant qui s’y trouve, peut lire vos échanges, comme avec n’importe quelle application. L’application Telegram elle-même le pourrait aussi. Avec une copie du stockage de l’application sur votre appareil, comme une copie forensique de votre téléphone, on peut ouvrir vos échanges et utiliser votre compte.

### Les captures d’écran

La personne à qui vous écrivez peut toujours copier ou photographier ce que vous envoyez. Supprimer un message des deux côtés demande à l’application de cette personne de l’effacer, mais ne peut pas atteindre une copie qu’elle en a faite.

## Utilisation

### Faut-il s’inscrire ?

Ni e-mail, ni numéro de téléphone, ni mot de passe : ouvrez le lien de quelqu’un dans Telegram, appuyez une fois sur **Configurer**, et écrivez. Pour l’instant, il faut une invitation pour obtenir votre propre lien.

### Que faire si quelqu’un m’importune ?

Bloquez cette personne : elle n’en est pas informée, et rien de ce qu’elle envoie ne vous parvient. Une personne qui configure un nouveau compte apparaît sous un nouveau nom : vous devrez donc peut-être la bloquer à nouveau. Vous pouvez aussi remplacer votre lien à tout moment : plus aucun nouvel échange ne peut commencer via l’ancien, mais les échanges déjà commencés continuent ; bloquez-y les personnes dont vous ne voulez pas recevoir de messages.

### Puis-je supprimer ce que j’ai envoyé ?

Oui. Par défaut, supprimer un message le supprime des deux côtés, qu’il ait été lu ou non. Vous pouvez aussi supprimer tout un échange des deux côtés, ou les échanges de votre liste en supprimant votre compte.

### Puis-je l’utiliser sur un autre téléphone ou ordinateur ?

Sur un seul appareil à la fois. Configurer l’application sur un autre appareil remplace votre compte : votre ancien lien cesse de fonctionner et, tant qu’il faut une invitation pour avoir un lien, il vous en faut une nouvelle pour obtenir à nouveau un lien. Vos anciens échanges restent sur l’ancien appareil, en lecture seule. Rien n’est transféré et rien n’est sauvegardé : si vous perdez votre téléphone, ou si Telegram ou le téléphone efface les données de l’application, les échanges qui s’y trouvaient sont perdus. Configurez à nouveau l’application sur un nouvel appareil : cela met fin immédiatement à l’ancien compte.

### Comment supprimer mon compte ?

Dans l’onglet **Mon lien**, appuyez sur **Supprimer le compte**. Tant que l’application reste ouverte, le serveur supprime en quelques minutes ce qu’il conserve pour vous, puis l’application supprime vos échanges et vos clés de cet appareil (sur certains appareils, des traces peuvent rester dans les fichiers de stockage de l’application). Les pièces jointes que vous avez envoyées restent disponibles pour que l’autre personne les récupère, jusqu’à ce qu’elles expirent, au plus tard au bout de 30 jours, sauf si vous cochez **Supprimer aussi mes échanges de l’autre côté** : alors, pour chaque échange de votre liste, l’application de l’autre personne reçoit la demande de le supprimer, et les pièces jointes que vous y avez envoyées sont supprimées du serveur (s’il en reste, elles expirent elles aussi au plus tard au bout de 30 jours).

### Combien de temps les données sont-elles conservées ?

Sur le serveur : les messages chiffrés jusqu’à ce que votre appareil les ait reçus, les pièces jointes jusqu’à ce qu’elles soient supprimées, 30 jours au maximum dans les deux cas. Votre compte (y compris votre lien, l’identifiant Telegram brouillé et le mois où vous avez ouvert l’application pour la dernière fois) est conservé jusqu’à ce que vous le supprimiez, ou jusqu’à ce que l’application reste 12 mois sans être ouverte. Sur votre appareil : vos échanges, jusqu’à ce que vous les supprimiez. Vous choisissez combien de temps les pièces jointes sont conservées (pour toujours, 1 mois ou 1 semaine) dans **Données et stockage**, sous l’onglet **Mon lien**.

## Le projet

### Est-ce gratuit ? Qui paie ?

C’est gratuit, sans publicité ni traceurs. C’est nous qui payons ce que coûte son fonctionnement (voir [Coûts](/fr/donate/#costs)), et les [dons](/fr/donate/) nous aident. Incognito Chat est un logiciel libre sous licence AGPL, développé au grand jour : [le code](https://github.com/{{< param "codeRepo" >}}) et [ce site](https://github.com/{{< param "siteRepo" >}}) sont sur GitHub.

### Comment vérifier tout cela ?

Vous n’avez pas à nous croire sur parole. La page [Vérifier](/fr/verify/) montre comment n’importe qui peut vérifier l’application, et la page [État](/fr/status/) montre les dernières vérifications automatiques. Les détails sont dans le [modèle de sécurité](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) et dans la liste de [ce que le logiciel stocke](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/data.md) (tous deux en anglais).

### J’ai trouvé un problème de sécurité

Merci de nous le dire d’abord en privé : voir [Sécurité](/fr/security/).
