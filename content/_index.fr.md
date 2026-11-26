---
title: "Incognito Chat"
lead: "Partagez votre lien personnel. Toute personne qui l’a peut vous écrire sans que vous sachiez qui elle est, et vous pouvez lui répondre. Les messages sont chiffrés sur votre appareil : personne d’autre ne peut les lire, pas même ceux qui gèrent le serveur."

preview:
  emoji: "🦊"
  sender: "K3F9"
  status: "Anonyme · via votre lien"
  messages:
    - side: in
      text: "Bonjour ! J’ai adoré votre conférence d’hier. Je peux vous poser une question ?"
    - side: out
      text: "Bien sûr, allez-y 🙂"
    - side: in
      text: "Comment avez-vous commencé ?"
  foot: "Chiffré de bout en bout"

how:
  title: "Comment ça marche"
  steps:
    - title: "Obtenez votre lien"
      text: "Ouvrez l’application dans Telegram et obtenez votre lien personnel. Remplacez-le quand vous voulez."
    - title: "Partagez-le"
      text: "Toute personne qui a Telegram peut vous écrire grâce à lui. Elle apparaît sous un nom comme **🦊 K3F9**, toujours le même, sans rien d’autre à son sujet."
    - title: "Discutez"
      text: "Texte, photos, vidéos, fichiers, messages vocaux, autocollants, réactions, modifications et suppression des deux côtés, comme dans n’importe quelle messagerie."

features:
  title: "Confidentialité"
  intro: "Tout cela découle de la façon dont l’application est conçue : c’est donc vrai même si vous ne nous faites pas confiance."
  items:
    - title: "Chiffré de bout en bout"
      text: "Chaque message et chaque pièce jointe est chiffré sur votre appareil. Seules les deux personnes d’un échange peuvent le lire."
    - title: "Aucun enregistrement de qui parle à qui"
      text: "Les messages transitent par des boîtes de réception aléatoires, jamais par les comptes. Rien de ce qui est stocké n’indique qui a écrit à qui, ni qui est l’expéditeur."
    - title: "Pas de connexion pour envoyer"
      text: "Chaque message consomme un jeton anonyme : les abus peuvent ainsi être limités sans apprendre qui envoie."
    - title: "Les échanges restent sur votre appareil"
      text: "Le serveur ne conserve les messages chiffrés que jusqu’à ce que votre appareil les ait reçus, 30 jours au maximum."
    - title: "Compilée au grand jour"
      text: "Un workflow GitHub public compile l’application à partir du code public, et c’est GitHub Pages qui la sert, pas nos serveurs. Chaque compilation est reproductible et signée dans un journal public."
    - title: "Gratuit, sans publicité ni traceurs"
      text: "Logiciel libre sous licence AGPL. Aucune mesure d’audience dans l’application ni sur ce site. Les dons aident à payer le service."

roadmap:
  title: "Feuille de route"
  items:
    - title: "Un serveur qui prouve ce qu’il exécute"
      text: "Nous prévoyons de déplacer le serveur dans une enclave attestée : une partie scellée de la machine dont tout le monde peut vérifier le code. Vous n’auriez alors plus à nous croire sur parole quant à ce que fait le serveur, et même nous ne pourrions pas savoir à quel compte Telegram appartient un lien."
    - title: "Des chiffres que personne ne peut falsifier"
      text: "La [page Statistiques](stats/) montre, heure par heure, les comptes créés, les messages envoyés et le volume de médias, et la [page Dons et coûts](donate/#costs) ce que coûte le fonctionnement du service ; tout est publié automatiquement et signé. Une fois l’enclave en service, c’est elle qui comptera et signera ces chiffres, pour que personne ne puisse les falsifier, pas même nous."

verify:
  title: "Vérifiez par vous-même"
  text: "Le code de l’application est public, chaque compilation est reproductible et signée, et un script vérifie que l’application ouverte par Telegram est exactement cette compilation. Le code du serveur est public lui aussi, mais pour l’instant, vous devez vous fier à nos propres registres de ce qui s’y exécute."
  button: "Comment vérifier"
  secondary: "Dernières vérifications"
---
