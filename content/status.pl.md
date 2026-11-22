---
title: "Status"
linkTitle: "Status"
description: "Automatyczne sprawdzenia, czy działająca aplikacja to dokładnie opublikowany kod: co godzinę, a raz dziennie z ponownym zbudowaniem z kodu źródłowego."
---

{{< status >}}

## Jak działają te sprawdzenia

[Zaplanowane zadanie](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) w publicznym repozytorium tej strony uruchamia [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh) z repozytorium kodu aplikacji i sprawdza nim działającą aplikację. Każdy log jest publiczny: otwórz dowolny, aby zobaczyć każde sprawdzenie i każdy plik. Aby samodzielnie przeprowadzić te same sprawdzenia, zobacz stronę [Weryfikacja aplikacji](/pl/verify/).
