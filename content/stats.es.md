---
title: "Estadísticas"
linkTitle: "Estadísticas"
description: "Cuánto se usa el servicio, hora a hora, y cuánto cuesta mantenerlo. Cifras reales, también las pequeñas."
---

{{< stats >}}

## Qué se cuenta

- **Cuentas configuradas**: las configuraciones completadas, incluidas las que se repiten en un dispositivo nuevo y las que se reintentan porque se perdió la respuesta.
- **Mensajes enviados**: los mensajes que escribe la gente, con texto, archivos adjuntos o stickers. No cuentan las confirmaciones de lectura, las reacciones, las ediciones, las eliminaciones ni las actualizaciones de claves, que la app marca como silenciosas (sin aviso). Los envíos a un enlace que ya no funciona también cuentan, porque el servidor les responde igual a propósito. Una app modificada podría marcar un mensaje como silencioso, o enviar más, hasta donde se lo permitan sus tokens.
- **Multimedia**: el tamaño de los archivos adjuntos pagados, con el relleno que la app añade a cada archivo (a una potencia de dos hasta 1 MiB, y después a MiB enteros), así que algo más que su tamaño real. Cuenta las subidas pagadas, no las terminadas, y todos los tipos de archivo juntos: el servidor no puede distinguir una foto de un mensaje de voz.
- **Costos**: lo que AWS cobra cada día por mantener el servicio, sin descontar créditos: producción por servicio, los cuatro mayores con su nombre, y el entorno de pruebas como un solo total. AWS corrige los últimos días durante un tiempo, y las cifras de este mes son estimaciones suyas.

Solo recuentos y sumas: nada de lo que hay aquí, ni en el lugar de donde salen los recuentos, dice quién hizo qué.

## De dónde salen las cifras

- El servidor de la app cuenta una vez por minuto, y AWS (CloudWatch) suma los recuentos por hora. Una [tarea programada](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/stats.yml) en el repositorio público de este sitio los lee cada hora, y los costos una vez al día, con un rol que solo puede leer métricas y costos.
- Los recuentos de una hora llevan la fecha en que el servidor los escribió, que en un servidor con poca actividad puede ser mucho más tarde: escribe los recuentos de un minuto con su siguiente solicitud, o cuando se apaga. Por eso una hora puede contener recuentos de horas anteriores. Cada ejecución vuelve a leer los últimos 7 días, así que una ejecución que se retrase o no llegue a hacerse no deja huecos, siempre que no pase más de una semana.
- La tarea guarda cada cifra que lee en la [rama `data`](https://github.com/{{< param "siteRepo" >}}/tree/data/stats) del repositorio, así que su historial es público, y firma con Sigstore cada archivo que escribe:

  ```shell
  gh attestation verify <file> --repo {{< param "siteRepo" >}} \
    --cert-identity https://github.com/{{< param "siteRepo" >}}/.github/workflows/stats.yml@refs/heads/main
  ```

- Eso demuestra que una cifra pasó por esta tarea pública sin cambios. No puede demostrar que lo que guarda AWS sea cierto: quien administra la cuenta de AWS podría cambiarlo. Cuando el servidor funcione en un enclave con atestación (consulta la hoja de ruta en la [página de inicio](/es/)), contará y firmará las cifras él mismo.
