---
title: "Estado"
linkTitle: "Estado"
description: "Comprobaciones automáticas de que la app en funcionamiento es exactamente el código publicado: cada hora, y cada día con una recompilación desde el código fuente."
---

{{< status >}}

## Cómo funcionan estas comprobaciones

Una [tarea programada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) en el repositorio público de este sitio ejecuta [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), del repositorio de código de la app, sobre la app en funcionamiento. Todos los registros son públicos: abre uno para ver cada comprobación y cada archivo. Para hacer las mismas comprobaciones por tu cuenta, consulta [Verificar la app](/es/verify/).
