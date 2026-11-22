---
title: "Segurança"
linkTitle: "Segurança"
description: "Como relatar uma vulnerabilidade no Incognito Chat."
updated: "2026-11-21"
---

Encontrou um jeito de ler as mensagens de alguém, ligar um remetente à conta dele ou qualquer outra coisa que quebre o que o app promete? Por favor, nos conte em particular primeiro.

## Como relatar

- **De preferência:** [relate em particular no GitHub](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Só os mantenedores veem o relato.
- **Ou por e-mail:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Conte o que você encontrou, como reproduzir e o que um atacante poderia fazer com isso.

## O que esperar

- Vamos responder em até uma semana e dizer o que vamos fazer a respeito.
- Corrigimos primeiro os problemas graves e, quando os usuários estiverem seguros, publicamos o que estava errado e como foi corrigido.
- Vamos dar o crédito a você, se você quiser.

## Por favor

- Teste com as suas próprias contas, ou com uma cópia que você mesmo rode. O [código](https://github.com/{{< param "codeRepo" >}}) tem tudo o que é preciso para rodar uma.
- Não acesse dados de outras pessoas e não atrapalhe o serviço para os outros.
- Dê um prazo razoável para corrigirmos antes de publicar.

Não vamos tomar medidas judiciais contra pesquisas feitas dessa forma.

## O que está no escopo

O app, o servidor, o protocolo, o processo de compilação e publicação, e este site. O que a arquitetura já admite que não consegue proteger está listado no [modelo de segurança](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (em inglês); novas formas de explorar esses limites continuam sendo bem-vindas.

Nosso [`security.txt`](/.well-known/security.txt) tem os mesmos contatos em um formato padrão.
