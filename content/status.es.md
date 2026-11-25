---
title: "Estado"
linkTitle: "Estado"
description: "Comprobaciones automáticas de que la app en funcionamiento es exactamente el código publicado, cada hora y cada día con una recompilación desde el código fuente, y de que el bot la abre."
---

{{< status >}}

## Cómo funcionan estas comprobaciones

Una [tarea programada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) en el repositorio público de este sitio ejecuta [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), del repositorio de código de la app, sobre la app en funcionamiento. Todos los registros son públicos: abre uno para ver cada comprobación y cada archivo. Para hacer las mismas comprobaciones por tu cuenta, consulta [Verificar la app](/es/verify/).

Otra [tarea programada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) ejecuta [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), también del repositorio de código de la app, cada hora con una cuenta de Telegram creada para esto. Le pregunta a Telegram qué abren los enlaces de la app (`t.me/{{< param "botUsername" >}}?startapp`) y el botón de menú del bot, y le envía /start al bot para leer el botón de su respuesta, todo sin abrir la app. Esto muestra lo que recibió esa cuenta en ese momento: una sustitución dirigida solo a personas elegidas, o una sustitución breve entre dos comprobaciones, no se vería aquí. Para comprobar lo que recibes tú, ejecuta el mismo script con tu propia cuenta ([cómo hacerlo, en inglés](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
