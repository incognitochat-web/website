---
title: "Estatísticas"
linkTitle: "Estatísticas"
description: "Quanto o serviço é usado, mês a mês, e quanto custa mantê-lo. Números reais."
---

{{< stats >}}

## O que é contado

- **Contas configuradas**: configurações concluídas, incluindo configurar de novo em um novo dispositivo e uma configuração repetida depois de uma resposta perdida.
- **Mensagens enviadas**: as mensagens que as pessoas escrevem, com texto, anexos ou stickers. Não contam confirmações de visualização, reações, edições, exclusões nem atualizações de chaves, que o app marca como silenciosas. Envios para um link que não funciona mais também contam, já que o servidor responde a eles do mesmo jeito, de propósito. Um app modificado poderia marcar uma mensagem como silenciosa, ou enviar mais, até onde os tokens dele permitirem.
- **Mídia**: o tamanho dos anexos pagos, com o preenchimento que o app aplica a todo arquivo (uma potência de dois até 1 MiB, depois MiB inteiros), então um pouco acima do tamanho real. Conta os uploads pagos, não os concluídos, e todos os tipos de arquivo juntos: o servidor não consegue distinguir uma foto de uma mensagem de voz.
- **Custos**: o que a AWS cobra para manter o serviço a cada dia, antes de qualquer crédito: a produção por serviço, com os quatro maiores pelo nome, e o ambiente de teste como um único total. A AWS revisa os últimos dias por algum tempo, e os números deste mês são estimativas dela.

Só contagens e somas: nada aqui, nem de onde vêm as contagens, diz quem fez o quê.

## De onde vêm os números

- O servidor do app conta uma vez por minuto, e a AWS (CloudWatch) soma as contagens por hora. Uma [tarefa agendada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/stats.yml) no repositório público deste site lê esses números a cada hora, e os custos uma vez por dia, com um perfil de acesso que só pode ler métricas e custos.
- As contagens de uma hora levam a data de quando o servidor as gravou, o que pode ser bem mais tarde em um servidor com pouco movimento: ele grava as contagens de um minuto junto com a próxima requisição, ou quando é desligado. Então uma hora pode conter contagens de horas anteriores. Cada execução lê de novo os últimos 7 dias, então execuções atrasadas ou perdidas por até uma semana não deixam lacunas.
- A tarefa guarda cada número que lê no [branch `data`](https://github.com/{{< param "siteRepo" >}}/tree/data/stats) do repositório, então o histórico deles é público, e assina com o Sigstore cada arquivo que grava:

  ```shell
  gh attestation verify <file> --repo {{< param "siteRepo" >}} \
    --cert-identity https://github.com/{{< param "siteRepo" >}}/.github/workflows/stats.yml@refs/heads/main
  ```

- Isso mostra que um número passou por essa tarefa pública sem alterações. Não pode mostrar que o que está na AWS é verdadeiro: quem administra a conta da AWS poderia alterar esses dados. Quando o servidor rodar em um enclave atestado (veja os próximos passos na [página inicial](/pt-br/)), ele mesmo vai contar e assinar os números.
