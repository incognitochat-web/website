---
title: "Status"
linkTitle: "Status"
description: "Verificações automáticas de que o app no ar é exatamente o código publicado, a cada hora e todos os dias com uma recompilação a partir do código-fonte, e de que o bot abre esse app."
---

{{< status >}}

## Como estas verificações funcionam

Uma [tarefa agendada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) no repositório público deste site executa o [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), do repositório de código do app, contra o app no ar. Todos os logs são públicos: abra um para ver cada verificação e cada arquivo. Para fazer as mesmas verificações você mesmo, veja [Verificar o app](/pt-br/verify/).

Outra [tarefa agendada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) executa o [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), também do repositório de código do app, a cada hora, com uma conta do Telegram criada para isso. Ela pergunta ao Telegram o que os links do app (`t.me/{{< param "botUsername" >}}?startapp`) e o botão de menu do bot abrem, e envia /start ao bot para ler o botão na resposta dele, tudo sem abrir o app. Isso mostra o que essa conta recebeu naquele momento: uma troca direcionada só a pessoas escolhidas, ou uma troca breve entre duas verificações, não apareceria aqui. Para verificar o que você recebe, rode o mesmo script com a sua própria conta ([como fazer, em inglês](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
