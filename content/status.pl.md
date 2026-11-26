---
title: "Status"
linkTitle: "Status"
description: "Automatyczne sprawdzenia, czy działająca aplikacja to dokładnie opublikowany kod (co godzinę, a raz dziennie z ponownym zbudowaniem z kodu źródłowego) i czy bot otwiera właśnie ją."
---

{{< status >}}

## Jak działają te sprawdzenia

Dwa zaplanowane zadania w publicznym repozytorium tej strony przeprowadzają sprawdzenia ze strony [Weryfikacja aplikacji](/pl/verify/), gdzie możesz też uruchomić je samodzielnie: [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) co godzinę sprawdza działającą aplikację, a raz dziennie także buduje ją ponownie z kodu źródłowego; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) co godzinę sprawdza, co otwiera bot, przy użyciu konta w Telegramie założonego specjalnie w tym celu. Log każdego uruchomienia jest publiczny. Sprawdzenie bota pokazuje tylko to, co zostało pokazane temu kontu w tamtej chwili: aby sprawdzić, co jest pokazywane tobie, [uruchom je na własnym koncie](/pl/verify/#bot-check).
