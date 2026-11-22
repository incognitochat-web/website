---
title: "Seguridad"
linkTitle: "Seguridad"
description: "Cómo informar sobre una vulnerabilidad en Incognito Chat."
updated: "2026-11-21"
---

¿Encontraste una forma de leer los mensajes de otra persona, de vincular a un remitente con su cuenta o cualquier otra cosa que rompa lo que promete la app? Por favor, avísanos primero en privado.

## Cómo informar

- **Preferible:** [infórmalo en privado en GitHub](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Solo lo ven quienes mantienen el proyecto.
- **O por correo electrónico:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Cuéntanos qué encontraste, cómo reproducirlo y qué podría hacer un atacante con ello.

## Qué esperar

- Te responderemos en el plazo de una semana y te diremos qué vamos a hacer al respecto.
- Primero corregimos los problemas graves, y cuando los usuarios ya estén a salvo publicamos qué fallaba y cómo se corrigió.
- Si quieres, te daremos el crédito.

## Por favor

- Haz las pruebas con tus propias cuentas o con una copia que ejecutes tú. El [código](https://github.com/{{< param "codeRepo" >}}) tiene todo lo necesario para ejecutar una.
- No accedas a datos de otras personas ni interrumpas el servicio para los demás.
- Danos un tiempo razonable para corregirlo antes de publicarlo.

No emprenderemos acciones legales contra la investigación que se haga de esta forma.

## Qué abarca

La app, el servidor, el protocolo, el proceso de compilación y publicación, y este sitio web. Lo que el diseño ya reconoce que no puede proteger aparece en el [modelo de seguridad](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (en inglés); las nuevas formas de aprovechar esos límites siguen siendo bienvenidas.

Nuestro [`security.txt`](/.well-known/security.txt) tiene los mismos contactos en un formato estándar.
