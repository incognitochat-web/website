---
title: "Incognito Chat"
lead: "Comparte tu enlace personal. Cualquiera que lo tenga puede escribirte sin que sepas quién es, y tú puedes responder. Los mensajes se cifran en tu dispositivo, así que nadie más puede leerlos, ni siquiera quien administra el servidor."

preview:
  emoji: "🦊"
  sender: "K3F9"
  status: "Anónimo · a través de tu enlace"
  messages:
    - side: in
      text: "¡Hola! Me encantó tu charla de ayer. ¿Puedo preguntarte algo?"
    - side: out
      text: "Claro, adelante 🙂"
    - side: in
      text: "¿Cómo empezaste?"
  foot: "Cifrado de extremo a extremo"

how:
  title: "Cómo funciona"
  steps:
    - title: "Consigue tu enlace"
      text: "Abre la app en Telegram y consigue tu enlace personal. Cámbialo por uno nuevo cuando quieras."
    - title: "Compártelo"
      text: "Cualquiera que tenga Telegram puede escribirte a través de él. Verás a esa persona como una etiqueta, por ejemplo **🦊 K3F9**, siempre la misma, y nada más sobre ella."
    - title: "Conversa"
      text: "Texto, fotos, videos, archivos, mensajes de voz, stickers, reacciones, ediciones y eliminación para ambos, como en cualquier chat."

features:
  title: "Privacidad"
  intro: "Todo esto se debe a cómo está hecha la app, así que se cumple aunque no confíes en nosotros."
  items:
    - title: "Cifrado de extremo a extremo"
      text: "Cada mensaje y cada archivo adjunto se cifra en tu dispositivo. Solo las dos personas de una conversación pueden leerlo."
    - title: "Ningún registro de quién habla con quién"
      text: "Los mensajes viajan por buzones aleatorios, nunca por cuenta. Nada de lo que se guarda indica quién escribió a quién, ni quién es el remitente."
    - title: "Enviar sin iniciar sesión"
      text: "Cada mensaje gasta un token anónimo, así que se pueden limitar los abusos sin averiguar quién envía."
    - title: "Los chats se quedan en tu dispositivo"
      text: "El servidor solo guarda los mensajes cifrados hasta que tu dispositivo los recibe, como máximo 30 días."
    - title: "Compilada a la vista de todos"
      text: "Un flujo de trabajo público de GitHub compila la app a partir del código público, y la sirve GitHub Pages, no nuestros servidores. Cada compilación es reproducible y está firmada en un registro público."
    - title: "Gratis, sin anuncios ni rastreadores"
      text: "Software libre bajo la licencia AGPL. Sin analíticas en la app ni en este sitio. Las donaciones ayudan a pagar los costos."

roadmap:
  title: "Hoja de ruta"
  items:
    - title: "Un servidor que demuestra lo que ejecuta"
      text: "Planeamos trasladar el servidor a un enclave con atestación: una parte sellada de la máquina cuyo código cualquiera puede comprobar. Así no tendrías que fiarte de nuestra palabra sobre lo que hace el servidor, y ni siquiera nosotros podríamos saber a qué cuenta de Telegram pertenece un enlace."
    - title: "Cifras que nadie puede falsificar"
      text: "La [página de estadísticas](stats/) muestra por hora las cuentas creadas, los mensajes enviados y el volumen de multimedia, y la [página de donaciones y costos](donate/#costs), cuánto cuesta mantener el servicio, todo publicado automáticamente y firmado. Cuando el enclave esté en marcha, contará y firmará esas cifras él mismo, así que nadie podrá falsificarlas, ni siquiera nosotros."

verify:
  title: "Compruébalo por tu cuenta"
  text: "El código de la app es público, cada compilación es reproducible y está firmada, y un script comprueba que la app que abre Telegram es exactamente esa compilación. El código del servidor también es público, pero por ahora tienes que confiar en nuestros registros de lo que se ejecuta en él."
  button: "Cómo verificar"
  secondary: "Últimas comprobaciones"
---
