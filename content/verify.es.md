---
title: "Verificar la app"
linkTitle: "Verificar"
description: "Cómo cualquiera puede comprobar que la app que abre Telegram es exactamente el código publicado."
updated: "2026-11-21"
---

El cifrado solo te protege si la app que usas es el código publicado. Dentro de Telegram, nada impide que quien administra el bot lo haga apuntar a otra página, así que la app se publica de una forma que cualquiera puede comprobar.

## Cómo se publica la app

- **Compilada a la vista de todos.** Un flujo de trabajo público en [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) compila una versión publicada del [código](https://github.com/{{< param "codeRepo" >}}), y ese repositorio no contiene ningún otro código.
- **Reproducible.** La misma versión siempre da archivos idénticos byte a byte al compilarla, así que cualquiera puede volver a compilarla y comparar.
- **Firmada en un registro público.** Ese flujo de trabajo firma con [Sigstore](https://www.sigstore.dev/) cada archivo, y también un `manifest.json` con el SHA-256 de cada uno. Las firmas están en un registro de transparencia público que no se puede reescribir sin que se note.
- **Una sola dirección, y nada más en ella.** La app solo se sirve desde `{{< param "appOrigin" >}}`, y allí nunca se sirve nada más: una página en la misma dirección podría llegar a las claves de tu dispositivo.
- **Sin nada externo.** La app no carga código de terceros, ni analíticas, ni código o ajustes del servidor.

## Compruébalo por tu cuenta

Desde una copia del [código](https://github.com/{{< param "codeRepo" >}}), con la sesión iniciada en la CLI de GitHub:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

El script comprueba que cada archivo servido es exactamente lo que el flujo de trabajo revisado, sin cambios, compiló a partir de una versión publicada en `main`, que la misma ejecución de ese flujo de trabajo lo desplegó y que ningún otro sitio comparte la dirección de la app. Con `--rebuild`, además, compila esa versión por su cuenta y compara byte a byte. Los detalles, y lo que no demuestra, están en [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (en inglés).

## Comprobación automática

El mismo script se ejecuta sobre la app en funcionamiento cada hora, y una vez al día con `--rebuild`. Los resultados, y lo que abarca cada comprobación, están en la página [Estado](/es/status/).

## Lo que esto no puede demostrar

- **Lo que se le mostró a una persona concreta dentro de Telegram.** El dueño del bot podría hacer que la app apunte a otra dirección, para todos o para personas elegidas. Una página en otra dirección no tiene ninguna de tus claves; para conseguir algo tendría que hacer que vuelvas a configurar la app, lo que cierra tu cuenta en tu dispositivo anterior de forma muy visible y cambia tu enlace.
- **Lo que ejecuta el servidor.** El diseño no depende de ello: un servidor malicioso puede descartar o retrasar mensajes y observar cuándo se envían y se reciben, pero no puede leerlos ni falsificarlos, porque la app comprueba cada clave por sí misma. Demostrar qué código ejecuta el servidor es un paso futuro (un enclave con atestación).
