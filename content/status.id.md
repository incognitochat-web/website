---
title: "Status"
linkTitle: "Status"
description: "Pemeriksaan otomatis bahwa aplikasi yang aktif persis sama dengan kode yang dipublikasikan: setiap jam, dan setiap hari dengan build ulang dari kode sumber."
---

{{< status >}}

## Cara kerja pemeriksaan ini

[Tugas terjadwal](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/check-app.yml) di repositori publik situs ini menjalankan [`verify-site.sh`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-site.sh), dari repositori kode aplikasi, terhadap aplikasi yang aktif. Setiap log bersifat publik: buka salah satunya untuk melihat setiap pemeriksaan dan setiap berkas. Untuk menjalankan sendiri pemeriksaan yang sama, lihat [Verifikasi aplikasi](/id/verify/).
