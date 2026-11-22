---
title: "Endereços oficiais"
linkTitle: "Endereços oficiais"
description: "O único bot verdadeiro, o endereço do app e onde fica o código. Qualquer outra coisa não é nossa."
updated: "2026-11-21"
---

Estes são os únicos endereços oficiais do Incognito Chat. **Qualquer outro não é nosso**, por mais parecido que seja o nome: não dá para confiar suas mensagens a cópias do bot ou do app.

{{< official >}}

## Como reconhecer

- **O nome de usuário do bot é exatamente `@{{< param "botUsername" >}}`.** Confira cada letra: nomes parecidos são o truque mais comum.
- **O app é sempre carregado de `{{< param "appOrigin" >}}`.** Suas chaves estão ligadas a esse endereço, então uma página carregada de qualquer outro lugar começa sem elas: ela não consegue ler suas mensagens anteriores e teria que pedir que você configure de novo.
- **O bot só envia uma breve mensagem de boas-vindas e notificações de “Nova mensagem”.** Uma notificação nunca diz quem escreveu nem o quê, e o bot nunca pede que você configure de novo nem que abra outro link.
- **Nunca é preciso configurar de novo**, a não ser que você tenha escolhido recomeçar. Se o app pedir que você configure sem que você tenha escolhido isso, não configure: você não está no app verdadeiro. Feche-o, confirme que você o abriu pelo `@{{< param "botUsername" >}}` e, se abriu, nos avise em [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

## Onde esta lista fica

Esta página é gerada a partir do [repositório público do site](https://github.com/{{< param "siteRepo" >}}), então toda mudança nela tem uma data pública.
