---
title: "Incognito Chat"
lead: "Compartilhe seu link pessoal. Qualquer pessoa com ele pode escrever para você sem que você saiba quem ela é, e você pode responder. As mensagens são criptografadas no seu dispositivo, então ninguém mais consegue lê-las, incluindo quem administra o servidor."

preview:
  emoji: "🦊"
  sender: "K3F9"
  status: "Anônimo · pelo seu link"
  messages:
    - side: in
      text: "Oi! Adorei sua palestra ontem. Posso fazer uma pergunta?"
    - side: out
      text: "Claro, pode perguntar 🙂"
    - side: in
      text: "Como você começou?"
  foot: "Criptografia de ponta a ponta"

how:
  title: "Como funciona"
  steps:
    - title: "Crie seu link"
      text: "Abra o app no Telegram e crie seu link pessoal. Troque-o por um novo quando quiser."
    - title: "Compartilhe"
      text: "Qualquer pessoa com Telegram pode escrever para você por ele. Ela aparece como um rótulo, por exemplo **🦊 K3F9**, sempre o mesmo, e você não vê mais nada sobre ela."
    - title: "Converse"
      text: "Texto, fotos, vídeos, arquivos, mensagens de voz, stickers, reações, edição e exclusão para os dois lados, como em qualquer chat."

features:
  title: "Privacidade"
  intro: "Isso vem da forma como o app é feito, então continua valendo mesmo que você não confie em nós."
  items:
    - title: "Criptografia de ponta a ponta"
      text: "Cada mensagem e cada anexo é criptografado no seu dispositivo. Só as duas pessoas de um chat conseguem lê-los."
    - title: "Nenhum registro de quem fala com quem"
      text: "As mensagens passam por caixas de entrada aleatórias, e não por contas. Nada do que fica guardado diz quem escreveu para quem, nem quem é o remetente."
    - title: "Sem login para enviar"
      text: "Cada mensagem gasta um token anônimo, então dá para limitar abusos sem descobrir quem envia."
    - title: "Os chats ficam no seu dispositivo"
      text: "O servidor só guarda as mensagens criptografadas até seu dispositivo recebê-las, por no máximo 30 dias."
    - title: "Compilado em público"
      text: "Um fluxo de trabalho público do GitHub compila o app a partir do código público, e quem o entrega é o GitHub Pages, não nossos servidores. Cada compilação é reproduzível e assinada em um registro público."
    - title: "Gratuito, sem anúncios, sem rastreadores"
      text: "Software livre sob a AGPL. Nenhuma ferramenta de análise no app nem neste site. Financiado por doações."

roadmap:
  title: "Próximos passos"
  items:
    - title: "Um servidor que prova o que executa"
      text: "Planejamos levar o servidor para um enclave atestado: uma parte isolada da máquina cujo código qualquer pessoa pode verificar. Assim, você não precisaria acreditar na nossa palavra sobre o que o servidor faz, e nem nós conseguiríamos saber qual conta do Telegram é dona de um link."
    - title: "Números que ninguém consegue falsificar"
      text: "A [página de estatísticas](stats/) mostra, hora a hora, as contas criadas, as mensagens enviadas e o volume de mídia, e quanto custa manter o serviço, tudo publicado automaticamente e assinado. Quando o enclave estiver no ar, ele mesmo vai contar e assinar esses números, então ninguém vai conseguir falsificá-los, nem nós."

verify:
  title: "Verifique você mesmo"
  text: "O código do app é público, cada compilação é reproduzível e assinada, e um script verifica se o app que o Telegram abre é exatamente essa compilação. O código do servidor também é público, mas, por enquanto, você precisa confiar nos nossos registros do que roda nele."
  button: "Como verificar"
  secondary: "Últimas verificações"
---
