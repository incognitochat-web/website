---
title: "Status"
linkTitle: "Status"
description: "Automatyczne sprawdzenia, czy działająca aplikacja to dokładnie opublikowany kod (co godzinę, a raz dziennie z ponownym zbudowaniem z kodu źródłowego) i czy bot otwiera właśnie ją."
---

{{< status >}}

## Jak działają te sprawdzenia

[Zaplanowane zadanie](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) w publicznym repozytorium tej strony uruchamia [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) z repozytorium kodu aplikacji i sprawdza nim działającą aplikację. Każdy log jest publiczny: otwórz dowolny, aby zobaczyć każde sprawdzenie i każdy plik. Aby samodzielnie przeprowadzić te same sprawdzenia, zobacz stronę [Weryfikacja aplikacji](/pl/verify/).

Kolejne [zaplanowane zadanie](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) co godzinę uruchamia [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), również z repozytorium kodu aplikacji, przy użyciu konta w Telegramie założonego specjalnie w tym celu. Skrypt pyta Telegram, co otwierają linki aplikacji (`t.me/{{< param "botUsername" >}}?startapp`) i przycisk menu bota, a także wysyła botowi /start, aby odczytać przycisk w jego odpowiedzi – wszystko to bez otwierania aplikacji. Wynik pokazuje, co dostało to konto w tamtej chwili: podmiana skierowana tylko do wybranych osób albo krótka podmiana między dwoma sprawdzeniami nie byłaby tu widoczna. Aby sprawdzić, co dostajesz ty, uruchom ten sam skrypt na własnym koncie ([jak to zrobić – po angielsku](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
