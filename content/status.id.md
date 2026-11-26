---
title: "Status"
linkTitle: "Status"
description: "Pemeriksaan otomatis bahwa aplikasi yang aktif persis sama dengan kode yang dipublikasikan, setiap jam dan setiap hari dengan build ulang dari kode sumber, dan bahwa bot membuka aplikasi itu."
---

{{< status >}}

## Cara kerja pemeriksaan ini

Dua tugas terjadwal di repositori publik situs ini menjalankan pemeriksaan dari [Verifikasi aplikasi](/id/verify/), tempat Anda juga bisa menjalankannya sendiri: [`check-app.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) memeriksa aplikasi yang aktif setiap jam, dan sekali sehari juga membangunnya ulang dari kode sumber; [`check-bot.yml`](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) memeriksa apa yang dibuka bot setiap jam, dengan akun Telegram yang dibuat untuk keperluan ini. Log setiap proses bersifat publik. Pemeriksaan bot hanya menunjukkan apa yang ditampilkan kepada akun itu pada saat itu: untuk memeriksa apa yang ditampilkan kepada Anda, [jalankan dengan akun Anda sendiri](/id/verify/#bot-check).
