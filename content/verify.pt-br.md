---
title: "Verificar o app"
linkTitle: "Verificar"
description: "Como qualquer pessoa pode verificar se o app que o Telegram abre é exatamente o código publicado."
updated: "2026-11-21"
---

A criptografia só protege você se o app que você usa for o código publicado. Dentro do Telegram, nada impede quem administra o bot de apontá-lo para outra página, então o app é publicado de um jeito que qualquer pessoa pode verificar.

## Como o app é publicado

- **Compilado em público.** Um fluxo de trabalho público em [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) compila uma versão publicada do [código](https://github.com/{{< param "codeRepo" >}}), sem nenhum outro código nesse repositório.
- **Reproduzível.** A mesma versão sempre gera arquivos idênticos byte a byte, então qualquer pessoa pode compilá-la de novo e comparar.
- **Assinado em um registro público.** Cada arquivo, e um `manifest.json` que lista o SHA-256 de cada um, é assinado com o [Sigstore](https://www.sigstore.dev/) por esse fluxo de trabalho. As assinaturas ficam em um registro público de transparência que não pode ser reescrito às escondidas.
- **Um endereço, e nada mais nele.** O app é carregado só de `{{< param "appOrigin" >}}`, e nunca há nada mais nesse endereço: uma página no mesmo endereço poderia chegar às chaves no seu dispositivo.
- **Nada carregado de fora.** O app não carrega código de terceiros, nem ferramentas de análise, nem código ou configurações do servidor.

## Verifique você mesmo

A partir de uma cópia do [código](https://github.com/{{< param "codeRepo" >}}), com o GitHub CLI logado:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Ele verifica se cada arquivo entregue é exatamente o que o fluxo de trabalho revisado e inalterado compilou a partir de uma versão publicada no `main`, se a mesma execução desse fluxo de trabalho o colocou no ar e se nenhum outro site compartilha o endereço do app. Com `--rebuild`, ele também compila essa versão por conta própria e compara byte a byte. Os detalhes, e o que ele não prova, estão em [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (em inglês).

## Verificado automaticamente

O mesmo script roda contra o app no ar a cada hora, e uma vez por dia com `--rebuild`. Os resultados, e o que cada verificação cobre, estão na página [Status](/pt-br/status/).

## O que isso não pode provar

- **O que uma pessoa específica viu dentro do Telegram.** O dono do bot poderia apontar o app para outro endereço, para todos ou para pessoas escolhidas. Uma página em outro endereço não tem nenhuma das suas chaves; para conseguir alguma coisa, ela teria que fazer você configurar de novo, o que encerra sua conta no dispositivo antigo de forma bem visível e muda seu link.
- **O que o servidor executa.** A arquitetura não depende disso: um servidor malicioso pode descartar ou atrasar mensagens e observar quando elas são enviadas e recebidas, mas não pode lê-las nem falsificá-las, porque o app verifica cada chave por conta própria. Provar o código do servidor é um passo futuro (um enclave atestado).
