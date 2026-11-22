---
title: "Verifikasi aplikasi"
linkTitle: "Verifikasi"
description: "Cara siapa pun bisa memeriksa bahwa aplikasi yang dibuka Telegram persis sama dengan kode yang dipublikasikan."
updated: "2026-11-21"
---

Enkripsi hanya melindungi Anda jika aplikasi yang Anda jalankan adalah kode yang dipublikasikan. Di dalam Telegram, tidak ada yang menghalangi siapa pun yang menjalankan bot untuk mengarahkannya ke halaman lain, jadi aplikasi ini dipublikasikan dengan cara yang bisa diperiksa siapa saja.

## Cara aplikasi dipublikasikan

- **Dibangun secara terbuka.** Alur kerja publik di [`{{< param "hostingRepo" >}}`](https://github.com/{{< param "hostingRepo" >}}) membangun satu rilis dari [kodenya](https://github.com/{{< param "codeRepo" >}}), dan repositori itu tidak berisi kode lain.
- **Dapat direproduksi.** Rilis yang sama selalu dibangun menjadi berkas yang identik byte demi byte, jadi siapa pun bisa membangunnya ulang dan membandingkannya.
- **Ditandatangani di log publik.** Setiap berkas, dan `manifest.json` yang berisi SHA-256 setiap berkas, ditandatangani dengan [Sigstore](https://www.sigstore.dev/) oleh alur kerja itu. Tanda tangannya ada di log transparansi publik yang tidak bisa diubah diam-diam.
- **Satu alamat, tidak ada yang lain di sana.** Aplikasi hanya dimuat dari `{{< param "appOrigin" >}}`, dan tidak pernah ada hal lain yang disajikan di sana: halaman di alamat yang sama bisa menjangkau kunci di perangkat Anda.
- **Terkunci rapat.** Aplikasi tidak memuat kode pihak ketiga, analitik, maupun kode atau pengaturan dari server.

## Periksa sendiri

Dari salinan lokal [kodenya](https://github.com/{{< param "codeRepo" >}}), dengan GitHub CLI yang sudah login:

```shell
scripts/verify-site.sh {{< param "appOrigin" >}} {{< param "hostingRepo" >}} --rebuild
```

Skrip ini memeriksa bahwa setiap berkas yang disajikan persis sama dengan yang dibangun dari sebuah rilis di `main` oleh alur kerja yang sudah ditinjau dan tidak diubah, bahwa proses alur kerja yang sama itulah yang memasangnya, dan bahwa tidak ada situs lain yang memakai alamat yang sama dengan aplikasi. Dengan `--rebuild`, skrip ini juga membangun sendiri rilis itu dan membandingkannya byte demi byte. Detailnya, dan apa yang tidak dibuktikannya, ada di [Verifying the app](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md) (dalam bahasa Inggris).

## Diperiksa otomatis

Skrip yang sama dijalankan terhadap aplikasi yang aktif setiap jam, dan sekali sehari dengan `--rebuild`. Hasilnya, dan apa yang dicakup setiap pemeriksaan, ada di halaman [Status](/id/status/).

## Yang tidak bisa dibuktikan

- **Apa yang ditampilkan kepada orang tertentu di dalam Telegram.** Pemilik bot bisa mengarahkan aplikasi ke alamat lain, untuk semua orang atau hanya untuk orang-orang yang dipilihnya. Halaman di alamat lain tidak punya kunci Anda; agar bisa berbuat apa-apa, halaman itu harus membuat Anda menyiapkan lagi, dan itu mengakhiri akun Anda di perangkat lama dengan cara yang terlihat jelas, serta mengganti tautan Anda.
- **Apa yang dijalankan server.** Desainnya tidak bergantung pada hal itu: server yang berniat jahat bisa membuang atau menunda pesan dan mengamati waktunya, tetapi tidak bisa membaca atau memalsukannya, karena aplikasi memeriksa sendiri setiap kunci. Membuktikan kode server adalah langkah ke depan (enclave teratestasi).
