---
title: "Status"
linkTitle: "Status"
description: "Verificações automáticas de que o app no ar é exatamente o código publicado: a cada hora, e todos os dias com uma recompilação a partir do código-fonte."
---

{{< status >}}

## Como estas verificações funcionam

Uma [tarefa agendada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) no repositório público deste site executa o [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), do repositório de código do app, contra o app no ar. Todos os logs são públicos: abra um para ver cada verificação e cada arquivo. Para fazer as mesmas verificações você mesmo, veja [Verificar o app](/pt-br/verify/).
