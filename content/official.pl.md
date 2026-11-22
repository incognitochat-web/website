---
title: "Oficjalne adresy"
linkTitle: "Oficjalne adresy"
description: "Jedyny prawdziwy bot, adres aplikacji i miejsce, gdzie jest kod. Wszystko inne to nie my."
updated: "2026-11-23"
---

To jedyne oficjalne adresy Incognito Chat. **Wszystko inne to nie my**, nawet jeśli nazwa jest bardzo podobna: kopiom bota ani aplikacji nie można powierzać swoich wiadomości.

{{< official >}}

## Jak je rozpoznać

- **Nazwa użytkownika bota to dokładnie `@{{< param "botUsername" >}}`.** Sprawdź każdą literę: podobnie wyglądające nazwy to najczęstsza sztuczka.
- **Aplikacja jest zawsze udostępniana z `{{< param "appOrigin" >}}`.** Twoje klucze są powiązane z tym adresem, więc strona udostępniana z dowolnego innego miejsca startuje bez nich: nie może przeczytać twoich wcześniejszych wiadomości i musiałaby poprosić cię o ponowną konfigurację.
- **Bot wysyła tylko krótkie powitanie i powiadomienia „Nowa wiadomość”.** Powiadomienie nigdy nie mówi, kto ani co napisał, a bot nigdy nie prosi cię o ponowną konfigurację ani o otwarcie innego linku.
- **Ponowna konfiguracja nigdy nie jest potrzebna**, chyba że to ty zdecydujesz się zacząć od nowa. Jeśli aplikacja prosi cię o konfigurację, choć to nie był twój wybór, nie rób tego: to nie jest prawdziwa aplikacja. Zamknij ją, upewnij się, że została otwarta z `@{{< param "botUsername" >}}`, a jeśli tak, napisz do nas na [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

## Gdzie jest przechowywana ta lista

Ta strona jest budowana z [publicznego repozytorium witryny](https://github.com/{{< param "siteRepo" >}}), więc każda jej zmiana ma publiczną datę.
