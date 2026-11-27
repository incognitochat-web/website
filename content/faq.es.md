---
title: "Preguntas y respuestas"
linkTitle: "Preguntas"
description: "Respuestas breves sobre lo que protege Incognito Chat, lo que no puede proteger y cómo usarlo."
updated: "2026-11-27"
---

## Privacidad

### ¿La persona a la que le escribo se entera de quién soy?

No. Ve una etiqueta como **🦊 K3F9**, la misma cada vez que le escribes a través de su enlace, y nada más sobre ti: ni tu nombre, ni tu nombre de usuario, ni tu número de teléfono. Las fotos y los videos que se envían como fotos o videos pierden su nombre de archivo y los datos ocultos, como la ubicación (en los videos, la mayoría de esos datos). Todo lo que se envía como archivo (con **Archivo**, o con **Comprimir imagen** o **Enviar como video** desactivado), y también la música, se envía tal cual, con su nombre de archivo y todo lo que contenga. Los GIF se envían sin su nombre de archivo, pero, por lo demás, tal cual.

### ¿Ustedes pueden leer mis mensajes?

No. Los mensajes y los archivos adjuntos se cifran en tu dispositivo, y solo las dos personas de una conversación pueden leerlos. El servidor guarda los mensajes, cifrados, solo hasta que el otro dispositivo los recibe, y los archivos adjuntos hasta que se eliminan: como máximo 30 días en ambos casos.

### ¿El servidor sabe quién le escribe a quién?

Nada de lo que guarda lo indica: los mensajes viajan por buzones aleatorios, no por cuenta, y se envían sin iniciar sesión. Pero quien administra los servidores podría observar el tráfico en tiempo real. Consulta [Alguien que observa en tiempo real](#live), más abajo.

### ¿Ustedes pueden saber de qué cuenta de Telegram es un enlace?

Hoy por hoy, sí, si decidiéramos buscarlo. El servidor guarda una versión ofuscada del ID de Telegram de cada cuenta, y quien tenga las claves del servidor puede averiguar el ID a partir de ella. Para la mayoría de los enlaces, esto importa poco: un enlace se crea para publicarlo o enviarlo, así que quien lo tiene normalmente ya sabe de quién es. Y saber de quién es el enlace no le dice a nadie quién te escribe, porque los mensajes se envían sin iniciar sesión.

### ¿Qué ve Telegram?

Que usas el bot, qué enlaces abres y cuándo se envían los avisos de «Nuevo mensaje». No lo que escribes: los mensajes viajan cifrados a través de nuestro servidor, nunca por chats de Telegram.

## Lo que no puede proteger

### Una página falsa dentro de Telegram

Quien controla el bot decide qué página abre Telegram, y Telegram no ofrece ninguna forma de fijarla. Una página servida desde cualquier lugar que no sea la [dirección oficial](/es/official/) no tiene ninguna de tus claves, así que no puede leer tus mensajes anteriores, pero lo que escribas en ella no está a salvo. Si alguna vez la app te pide volver a configurarla sin que tú lo hayas decidido, no lo hagas. Cualquiera puede [comprobar](/es/verify/) que la dirección oficial sirve exactamente el código publicado.

### Alguien que observa en tiempo real {#live}

Quien administra los servidores, o Amazon, que los aloja, podría observar las solicitudes en tiempo real y relacionar a las personas por los horarios y las direcciones IP: un mensaje que llega, luego un aviso, luego una respuesta o un «Visto». Telegram también podría relacionar a las personas por los horarios. Una copia de los datos guardados no muestra esto, pero, con las claves del servidor, unos registros que se conservan hasta un día, a veces unos días más, muestran una parte.

### Tu propio dispositivo

La app funciona dentro de Telegram, en tu teléfono o tu computadora. Cualquiera que pueda usar tu dispositivo desbloqueado, o un programa malicioso que haya en él, puede leer tus chats, como con cualquier app. La propia app de Telegram también podría hacerlo. Con una copia del almacenamiento de la app en tu dispositivo, como una copia forense de tu teléfono, se pueden abrir tus chats y usar tu cuenta.

### Capturas de pantalla

La persona a la que le escribes siempre puede copiar o fotografiar lo que envías. Eliminar un mensaje para ambos le pide a la app de esa persona que lo borre, pero no puede llegar a una copia que haya hecho.

## Cómo se usa

### ¿Tengo que registrarme?

Sin correo electrónico, número de teléfono ni contraseña: abre el enlace de alguien en Telegram, toca **Configurar** una vez y escribe. Por ahora, para tener tu propio enlace necesitas una invitación.

### ¿Y si alguien me molesta?

Bloquea a esa persona: no se le avisa, y no te llega nada de lo que envíe. Si configura una cuenta nueva, aparece con una etiqueta nueva, así que puede que tengas que volver a bloquearla. También puedes cambiar tu enlace por uno nuevo cuando quieras: a través del anterior ya no se pueden iniciar chats nuevos, pero los que ya empezaron continúan; en ellos, bloquea a quien no quieras que te siga escribiendo.

### ¿Puedo eliminar lo que envié?

Sí. Al eliminar un mensaje, se elimina para ambos de forma predeterminada, se haya leído o no. También puedes eliminar un chat entero para ambos, o los chats de tu lista al eliminar tu cuenta.

### ¿Puedo usarlo en otro teléfono o computadora?

En un solo dispositivo a la vez. Configurar la app en otro dispositivo reemplaza tu cuenta: tu enlace anterior deja de funcionar y, mientras los enlaces requieran una invitación, necesitas una nueva para volver a tener un enlace. Tus chats anteriores se quedan en el dispositivo anterior, de solo lectura. Nada se traslada y no se hace ninguna copia de seguridad, así que, si pierdes tu teléfono, o si Telegram o el teléfono borra los datos de la app, sus chats se pierden. Vuelve a configurar la app en uno nuevo: eso cierra la cuenta anterior de inmediato.

### ¿Cómo elimino mi cuenta?

En la pestaña **Ajustes**, toca **Eliminar cuenta**. Mientras la app siga abierta, el servidor elimina en cuestión de minutos lo que guarda para ti, y después la app elimina tus chats y tus claves de este dispositivo (en algunos dispositivos, pueden quedar rastros en los archivos de almacenamiento de la app). Los archivos adjuntos que enviaste se quedan disponibles para que la otra persona los descargue hasta que expiren, en un plazo de 30 días, salvo que marques **Eliminar también mis chats para la otra persona**: entonces, en cada chat de tu lista, se le pide a la app de la otra persona que lo elimine, y los archivos adjuntos que enviaste ahí se eliminan del servidor (los que queden expiran de todos modos en un plazo de 30 días).

### ¿Cuánto tiempo se conserva todo?

En el servidor: los mensajes cifrados, hasta que tu dispositivo los recibe; los archivos adjuntos, hasta que se eliminan; como máximo 30 días en ambos casos. Tu cuenta (incluidos tu enlace, el ID de Telegram ofuscado y el mes en que abriste la app por última vez) se conserva hasta que la eliminas o hasta que pasan 12 meses sin que se abra la app. En tu dispositivo: tus chats, hasta que los eliminas. En **Datos y almacenamiento**, en la pestaña **Ajustes**, eliges cuánto tiempo se conservan los archivos adjuntos (siempre, 1 mes o 1 semana).

## El proyecto

### ¿Es gratis? ¿Quién lo paga?

Es gratis, sin anuncios ni rastreadores. Nosotros pagamos lo que cuesta mantenerlo (consulta [Costos](/es/donate/#costs)), y las [donaciones](/es/donate/) ayudan. Incognito Chat es software libre bajo la licencia AGPL, desarrollado a la vista de todos: [el código](https://github.com/{{< param "codeRepo" >}}) y [este sitio](https://github.com/{{< param "siteRepo" >}}) están en GitHub.

### ¿Cómo puedo comprobar todo esto?

No tienes por qué fiarte de nuestra palabra. La página [Verificar](/es/verify/) muestra cómo cualquiera puede comprobar la app, y [Estado](/es/status/) muestra las últimas comprobaciones automáticas. Los detalles están en el [modelo de seguridad](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) y en la lista de [lo que guarda el software](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/data.md) (ambos en inglés).

### Encontré un problema de seguridad

Por favor, avísanos primero en privado: consulta [Seguridad](/es/security/).
