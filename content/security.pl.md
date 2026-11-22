---
title: "Bezpieczeństwo"
linkTitle: "Bezpieczeństwo"
description: "Jak zgłosić podatność w Incognito Chat."
updated: "2026-11-21"
---

Udało ci się znaleźć sposób, by przeczytać czyjeś wiadomości, powiązać nadawcę z jego kontem albo w inny sposób złamać to, co obiecuje aplikacja? Prosimy, najpierw powiedz nam o tym prywatnie.

## Jak zgłosić

- **Najlepiej:** [zgłoś to prywatnie na GitHubie](https://github.com/{{< param "codeRepo" >}}/security/advisories/new). Widzą to tylko opiekunowie projektu.
- **Albo e-mailem:** [{{< param "securityEmail" >}}](mailto:{{< param "securityEmail" >}}).

Opisz, na czym polega problem, jak go odtworzyć i co atakujący mógłby z nim zrobić.

## Czego się spodziewać

- Odpowiemy w ciągu tygodnia i powiemy, co z tym zrobimy.
- Poważne problemy naprawiamy w pierwszej kolejności, a gdy użytkownicy są już bezpieczni, publikujemy, co było nie tak i jak to naprawiono.
- Jeśli chcesz, wymienimy cię w podziękowaniach.

## Nasze prośby

- Testuj na własnych kontach albo na kopii uruchomionej u siebie. [Kod](https://github.com/{{< param "codeRepo" >}}) zawiera wszystko, czego potrzeba, by ją uruchomić.
- Nie uzyskuj dostępu do danych innych osób i nie zakłócaj działania usługi innym.
- Zanim opublikujesz swoje odkrycie, daj nam rozsądny czas na naprawę.

Nie podejmiemy kroków prawnych wobec badań prowadzonych w ten sposób.

## Zakres

Aplikacja, serwer, protokół, proces kompilacji i publikacji oraz ta strona. Ograniczenia, do których projekt już się przyznaje, są wymienione w [modelu bezpieczeństwa](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) (po angielsku); nowe sposoby ich wykorzystania nadal są mile widziane.

Nasz plik [`security.txt`](/.well-known/security.txt) zawiera te same kontakty w standardowej formie.
