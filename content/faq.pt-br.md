---
title: "Perguntas e respostas"
linkTitle: "Perguntas"
description: "Respostas curtas sobre o que o Incognito Chat protege, o que ele não consegue proteger e como usá-lo."
updated: "2026-11-22"
---

## Privacidade

### A pessoa para quem eu escrevo fica sabendo quem eu sou?

Não. Ela vê um rótulo como **🦊 K3F9**, sempre o mesmo quando você escreve pelo link dela, e mais nada sobre você: nem seu nome, nem seu nome de usuário, nem seu número de telefone. As fotos e os vídeos enviados como fotos ou vídeos perdem o nome do arquivo e os dados ocultos, como a localização (nos vídeos, a maior parte desses dados). Tudo o que é enviado como arquivo (com **Arquivo**, ou com **Comprimir imagem** ou **Enviar como vídeo** desativado), e também músicas, vai do jeito que está, com o nome do arquivo e tudo o que houver dentro dele. GIFs vão sem o nome do arquivo, mas, fora isso, do jeito que estão.

### Vocês conseguem ler minhas mensagens?

Não. As mensagens e os anexos são criptografados no seu dispositivo, e só as duas pessoas de um chat conseguem lê-los. O servidor guarda as mensagens, criptografadas, só até o outro dispositivo recebê-las, e os anexos até serem apagados: no máximo 30 dias, nos dois casos.

### O servidor sabe quem escreve para quem?

Nada do que ele guarda diz isso: as mensagens passam por caixas de entrada aleatórias, e não por contas, e são enviadas sem login. Mas quem administra os servidores poderia observar o tráfego em tempo real. Veja [Alguém observando em tempo real](#live), mais abaixo.

### Vocês conseguem saber qual conta do Telegram é dona de um link?

Hoje, sim, se resolvêssemos procurar. O servidor guarda uma versão embaralhada do ID do Telegram de cada conta, e quem tem as chaves do servidor consegue descobrir o ID a partir dela. Para a maioria dos links, isso importa pouco: um link é feito para ser publicado ou enviado, então quem está com ele normalmente já sabe de quem ele é. E saber de quem é o link não revela a ninguém quem escreve para você, já que as mensagens são enviadas sem login. Levar o servidor para um enclave, algo que está [nos próximos passos](/pt-br/#roadmap), tiraria essa possibilidade de nós também.

### O que o Telegram vê?

Que você usa o bot, quais links você abre e quando as notificações de “Nova mensagem” são enviadas. Não o que você escreve: as mensagens passam criptografadas pelo nosso servidor, nunca por chats do Telegram.

## O que ele não consegue proteger

### Uma página falsa dentro do Telegram

Quem controla o bot decide qual página o Telegram abre, e o Telegram não oferece nenhum jeito de travá-la. Uma página carregada de qualquer lugar que não seja o [endereço oficial](/pt-br/official/) não tem nenhuma das suas chaves, então não consegue ler suas mensagens anteriores, mas o que você digitar nela não está seguro. Se algum dia o app pedir que você configure de novo sem que você tenha escolhido isso, não configure. Qualquer pessoa pode [verificar](/pt-br/verify/) se o endereço oficial entrega exatamente o código publicado.

### Alguém observando em tempo real {#live}

Quem administra os servidores, ou a Amazon, que os hospeda, poderia observar as requisições em tempo real e relacionar as pessoas cruzando horários e endereços IP: uma mensagem chegando, depois uma notificação, depois uma resposta ou a marca “Visualizada”. O Telegram também poderia relacionar as pessoas pelos horários. Uma cópia dos dados guardados não mostra isso, mas, com as chaves do servidor, registros mantidos por até um dia, às vezes alguns dias a mais, mostram parte disso. Mesmo com o enclave, os horários e os endereços IP continuariam visíveis.

### Seu próprio dispositivo

O app roda dentro do Telegram, no seu celular ou computador. Qualquer pessoa que consiga usar seu dispositivo desbloqueado, ou um malware instalado nele, consegue ler seus chats, como em qualquer app. O próprio app do Telegram também poderia. Com uma cópia do armazenamento do app no seu dispositivo, como uma cópia forense do seu celular, é possível abrir seus chats e usar sua conta.

### Capturas de tela

A pessoa para quem você escreve sempre pode copiar ou fotografar o que você envia. Apagar uma mensagem para os dois lados pede ao app da pessoa que a remova, mas não alcança uma cópia que ela tenha feito.

## Como usar

### Preciso me cadastrar?

Sem e-mail, sem número de telefone, sem senha: abra o link de alguém no Telegram, toque em **Configurar** uma vez e escreva. Por enquanto, para ter seu próprio link, é preciso um convite.

### E se alguém me incomodar?

Bloqueie a pessoa: ela não é avisada, e nada do que ela enviar chega até você. Se ela configurar uma nova conta, vai aparecer com um novo rótulo, então talvez você precise bloqueá-la de novo. Você também pode trocar seu link por um novo a qualquer momento: nenhum chat novo pode começar pelo antigo, mas os chats já iniciados continuam: neles, bloqueie quem você não quiser que siga falando com você.

### Posso apagar o que enviei?

Sim. Por padrão, quando você apaga uma mensagem, ela é apagada para os dois lados, lida ou não. Você também pode apagar um chat inteiro para os dois lados, ou todos os seus chats ao apagar sua conta.

### Posso usar em outro celular ou computador?

Um dispositivo por vez. Configurar em outro dispositivo substitui sua conta: seu link antigo para de funcionar e, enquanto os links precisarem de convite, você precisa de um novo convite para voltar a ter um link. Seus chats antigos ficam no dispositivo antigo, só para leitura. Nada é transferido e não há backup de nada, então, se você perder o celular, ou se o Telegram ou o celular apagar os dados do app, os chats dele se perdem. Configure de novo em um novo celular: isso encerra a conta antiga na hora.

### Como apago minha conta?

Na aba **Meu link**, toque em **Apagar conta**. Enquanto o app continuar aberto, o servidor apaga em poucos minutos o que guarda para você, e depois o app apaga seus chats e chaves deste dispositivo (em alguns dispositivos, podem ficar vestígios nos arquivos de armazenamento do app). Os anexos que você enviou continuam disponíveis para a outra pessoa baixar até expirarem, em até 30 dias, a menos que você marque **Apagar também meus chats para a outra pessoa**: nesse caso, em cada chat da sua lista, o app da outra pessoa recebe um pedido para apagá-lo, e os anexos que você enviou ali são apagados do servidor (os que sobrarem também expiram em até 30 dias).

### Por quanto tempo as coisas ficam guardadas?

No servidor: as mensagens criptografadas, até seu dispositivo recebê-las; os anexos, até serem apagados; no máximo 30 dias, nos dois casos. Sua conta (incluindo seu link, o ID do Telegram embaralhado e o mês em que você abriu o app pela última vez) fica guardada até você apagá-la, ou até o app passar 12 meses sem ser aberto. No seu dispositivo: seus chats, até você apagá-los. Em **Dados e armazenamento**, na aba **Meu link**, você escolhe por quanto tempo os anexos ficam guardados (sempre, 1 mês ou 1 semana).

## O projeto

### É gratuito? Quem paga por isso?

É gratuito, sem anúncios e sem rastreadores. Por enquanto, nós pagamos o que custa mantê-lo no ar (veja [Custos](/pt-br/costs/)); as doações vão ajudar quando forem abertas. O Incognito Chat é software livre sob a AGPL, desenvolvido de forma aberta: [o código](https://github.com/{{< param "codeRepo" >}}) e [este site](https://github.com/{{< param "siteRepo" >}}) estão no GitHub.

### Como posso verificar tudo isso?

Você não precisa acreditar na nossa palavra. A página [Verificar](/pt-br/verify/) mostra como qualquer pessoa pode verificar o app, e a página [Status](/pt-br/status/) mostra as últimas verificações automáticas. Os detalhes estão no [modelo de segurança](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) e na lista do [que o software guarda](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/data.md) (ambos em inglês).

### Encontrei um problema de segurança

Por favor, nos conte em particular primeiro: veja [Segurança](/pt-br/security/).
