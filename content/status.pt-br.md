---
title: "Status"
linkTitle: "Status"
description: "Verificações automáticas de que o app no ar é exatamente o código publicado, a cada hora e todos os dias com uma recompilação a partir do código-fonte, e de que o bot abre esse app."
---

{{< status >}}

## Como estas verificações funcionam

Duas tarefas agendadas no repositório público deste site executam as verificações de [Verificar o app](/pt-br/verify/), onde você também pode fazê-las por conta própria: o [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) verifica o app no ar a cada hora e, uma vez por dia, também o recompila a partir do código-fonte; o [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) verifica a cada hora o que o bot abre, com uma conta do Telegram criada para isso. O log de cada execução é público. A verificação do bot indica só o que foi mostrado a essa conta naquele momento: para verificar o que é mostrado a você, [rode-a com a sua própria conta](/pt-br/verify/#bot-check).
