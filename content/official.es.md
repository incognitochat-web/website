---
title: "Direcciones oficiales"
linkTitle: "Direcciones oficiales"
description: "El único bot real, la dirección de la app y dónde está el código. Cualquier otra cosa no somos nosotros."
updated: "2026-11-23"
---

Estas son las únicas direcciones oficiales de Incognito Chat. **Cualquier otra cosa no somos nosotros**, por mucho que se parezca el nombre: a las copias del bot o de la app no se les pueden confiar tus mensajes.

{{< official >}}

## Cómo reconocerlas

- **El nombre de usuario del bot es exactamente `@{{< param "botUsername" >}}`.** Revisa cada letra: los nombres parecidos son el truco más común.
- **La app siempre se sirve desde `{{< param "appOrigin" >}}`.** Tus claves están ligadas a esa dirección, así que una página servida desde cualquier otro lugar empieza sin ellas: no puede leer tus mensajes anteriores y tendría que pedirte que vuelvas a configurar la app.
- **El bot solo envía una breve bienvenida y avisos de «Nuevo mensaje».** Un aviso nunca dice quién escribió ni qué, y el bot nunca te pide que vuelvas a configurar la app ni que abras otro enlace.
- **Nunca hace falta volver a configurar la app**, salvo que tú hayas decidido empezar de nuevo. Si la app te pide configurarla sin que lo hayas decidido, no lo hagas: no estás en la app real. Ciérrala, asegúrate de haberla abierto desde `@{{< param "botUsername" >}}` y, si fue así, escríbenos a [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

## Dónde está esta lista

Esta página se genera a partir del [repositorio público del sitio](https://github.com/{{< param "siteRepo" >}}), así que cada cambio que se le hace tiene una fecha pública.
