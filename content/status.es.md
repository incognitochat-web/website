---
title: "Estado"
linkTitle: "Estado"
description: "Comprobaciones automáticas de que la app en funcionamiento es exactamente el código publicado, cada hora y cada día con una recompilación desde el código fuente, y de que el bot la abre."
---

{{< status >}}

## Cómo funcionan estas comprobaciones

Dos tareas programadas en el repositorio público de este sitio ejecutan las comprobaciones de [Verificar la app](/es/verify/), donde también puedes hacerlas por tu cuenta: [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) comprueba la app en funcionamiento cada hora y, una vez al día, también la recompila desde el código fuente; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) comprueba cada hora qué abre el bot, con una cuenta de Telegram creada para esto. El registro de cada ejecución es público. La comprobación del bot solo indica lo que se le mostró a esa cuenta en ese momento: para comprobar lo que se te muestra a ti, [ejecútala con tu propia cuenta](/es/verify/#bot-check).
