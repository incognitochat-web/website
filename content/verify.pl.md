---
title: "Weryfikacja aplikacji"
linkTitle: "Weryfikacja"
description: "Jak każdy może sprawdzić, czy aplikacja otwierana przez Telegram to dokładnie opublikowany kod."
updated: "2026-11-21"
---

Szyfrowanie chroni cię tylko wtedy, gdy uruchamiana przez ciebie aplikacja to opublikowany kod. W Telegramie nic nie powstrzymuje tego, kto prowadzi bota, przed skierowaniem go na inną stronę, dlatego aplikacja jest publikowana w sposób, który każdy może sprawdzić.

## Jak aplikacja jest publikowana

- **Budowana publicznie.** Publiczny workflow w [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) buduje jedno wydanie [kodu](https://github.com/{{< param "codeRepo" >}}), a w tym repozytorium nie ma żadnego innego kodu.
- **Powtarzalna.** To samo wydanie zawsze daje pliki identyczne co do bajtu, więc każdy może je zbudować ponownie i porównać.
- **Podpisana w publicznym rejestrze.** Każdy plik, a także `manifest.json` z SHA-256 każdego z nich, jest podpisywany przez ten workflow za pomocą [Sigstore](https://www.sigstore.dev/). Podpisy są w publicznym rejestrze przejrzystości, którego nie da się po cichu zmienić.
- **Jeden adres, nic więcej pod nim.** Aplikacja jest udostępniana tylko z `{{< param "appOrigin" >}}` i nic innego nigdy nie jest tam udostępniane: strona pod tym samym adresem mogłaby dostać się do kluczy na twoim urządzeniu.
- **Szczelna.** Aplikacja nie wczytuje kodu stron trzecich ani analityki, a z serwera nie pobiera żadnego kodu ani ustawień.

## Sprawdź to samodzielnie

W lokalnej kopii [kodu](https://github.com/{{< param "codeRepo" >}}), po zalogowaniu się w GitHub CLI:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Skrypt sprawdza, czy każdy udostępniany plik to dokładnie to, co niezmieniony, sprawdzony workflow zbudował z wydania na `main`, czy wdrożyło go to samo uruchomienie workflow i czy żadna inna strona nie dzieli adresu z aplikacją. Z `--rebuild` sam też buduje to wydanie i porównuje je bajt po bajcie. Szczegóły, a także to, czego skrypt nie dowodzi, są w dokumencie [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (po angielsku).

## Sprawdzana automatycznie

Ten sam skrypt sprawdza działającą aplikację co godzinę, a raz dziennie także z `--rebuild`. Wyniki i to, co obejmuje każde sprawdzenie, są na stronie [Status](/pl/status/).

## Czego to nie dowodzi

- **Co konkretnej osobie pokazano w Telegramie.** Właściciel bota mógłby skierować aplikację na inny adres, dla wszystkich albo dla wybranych osób. Strona pod innym adresem nie ma żadnego z twoich kluczy; żeby cokolwiek osiągnąć, musiałaby skłonić cię do ponownej konfiguracji, co w widoczny sposób kończy twoje konto na starym urządzeniu i zmienia twój link.
- **Co działa na serwerze.** Projekt od tego nie zależy: złośliwy serwer może gubić lub opóźniać wiadomości i obserwować, kiedy są przesyłane, ale nie może ich odczytać ani sfałszować, bo aplikacja sama sprawdza każdy klucz. Udowodnienie, jaki kod działa na serwerze, to przyszły krok (atestowana enklawa).
