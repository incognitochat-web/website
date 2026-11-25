---
title: "Status"
linkTitle: "Status"
description: "Pemeriksaan otomatis bahwa aplikasi yang aktif persis sama dengan kode yang dipublikasikan, setiap jam dan setiap hari dengan build ulang dari kode sumber, dan bahwa bot membuka aplikasi itu."
---

{{< status >}}

## Cara kerja pemeriksaan ini

[Tugas terjadwal](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) di repositori publik situs ini menjalankan [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), dari repositori kode aplikasi, terhadap aplikasi yang aktif. Setiap log bersifat publik: buka salah satunya untuk melihat setiap pemeriksaan dan setiap berkas. Untuk menjalankan sendiri pemeriksaan yang sama, lihat [Verifikasi aplikasi](/id/verify/).

[Tugas terjadwal](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-bot.yml) lainnya menjalankan [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py), juga dari repositori kode aplikasi, setiap jam dengan akun Telegram yang dibuat khusus untuk pemeriksaan ini. Tugas ini menanyakan kepada Telegram apa yang dibuka oleh tautan aplikasi (`t.me/{{< param "botUsername" >}}?startapp`) dan tombol menu bot, lalu mengirim /start ke bot untuk membaca tombol di balasannya, semuanya tanpa membuka aplikasi. Hasilnya menunjukkan apa yang diterima akun tersebut pada saat itu: penggantian yang hanya ditujukan kepada orang-orang yang dipilih, atau penggantian singkat di antara dua pemeriksaan, tidak akan terlihat di sini. Untuk memeriksa apa yang Anda terima, jalankan skrip yang sama dengan akun Anda sendiri ([caranya, dalam bahasa Inggris](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens)).
