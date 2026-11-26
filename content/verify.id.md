---
title: "Verifikasi aplikasi"
linkTitle: "Verifikasi"
description: "Cara siapa pun bisa memeriksa bahwa aplikasi yang dibuka Telegram persis sama dengan kode yang dipublikasikan."
updated: "2026-11-26"
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

## Periksa apa yang dibuka bot {#bot-check}

Siapa pun yang menjalankan bot menentukan alamat mana yang dibuka Telegram, jadi [`verify-bot.py`](https://github.com/{{< param "codeRepo" >}}/blob/main/scripts/verify-bot.py) memeriksa separuh lainnya, sebagaimana dilihat oleh akun Telegram Anda sendiri, tanpa membuka aplikasi:

- tautan aplikasi (`t.me/{{< param "botUsername" >}}?startapp`),
- tombol menu bot,
- tombol di balasan bot untuk /start (skrip mengirim /start, lalu menghapus pesan-pesan itu).

Masing-masing harus membuka persis `{{< param "appOrigin" >}}/`. Anda memerlukan Python 3.11 atau yang lebih baru, `api_id` dan `api_hash` milik Anda sendiri dari [my.telegram.org](https://my.telegram.org), dan login Telegram Anda: Anda mengetikkan nomor telepon Anda dan kode yang dikirim Telegram kepada Anda, login itu tetap berada di memori, dan skrip melakukan logout di akhir. Dari salinan lokal kodenya:

```shell
python3 -m venv ~/.cache/verify-bot
~/.cache/verify-bot/bin/pip install --require-hashes --only-binary :all: -r scripts/verify-bot.build.txt
~/.cache/verify-bot/bin/pip install --require-hashes --no-build-isolation -r scripts/verify-bot.requirements.txt
TG_API_ID=<id> TG_API_HASH=<hash> ~/.cache/verify-bot/bin/python scripts/verify-bot.py {{< param "botUsername" >}} {{< param "appOrigin" >}}
```

Detailnya ada di [Checking what the bot opens](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/verifying.md#checking-what-the-bot-opens) (dalam bahasa Inggris).

## Diperiksa otomatis

Kedua skrip berjalan sesuai jadwal, secara terbuka: `verify-site.sh` terhadap aplikasi yang aktif setiap jam, dan sekali sehari dengan `--rebuild`; `verify-bot.py` setiap jam, dengan akun Telegram yang dibuat untuk keperluan ini. Hasilnya ada di halaman [Status](/id/status/).

## Yang tidak bisa dibuktikan

- **Apa yang ditampilkan kepada orang lain di dalam Telegram.** Pemilik bot bisa mengarahkan aplikasi ke alamat lain hanya untuk orang-orang yang dipilihnya, atau selama beberapa menit di antara pemeriksaan. Pemeriksaan setiap jam hanya melihat apa yang ditampilkan kepada akunnya sendiri, dan pemeriksaan yang Anda jalankan sendiri hanya melihat apa yang ditampilkan kepada Anda. Halaman di alamat lain tidak punya kunci Anda; agar bisa berbuat apa-apa, halaman itu harus membuat Anda menyiapkan lagi, dan itu mengakhiri akun Anda di perangkat lama dengan cara yang terlihat jelas, serta mengganti tautan Anda.
- **Apa yang dijalankan server.** Desainnya tidak bergantung pada hal itu: server yang berniat jahat bisa membuang atau menunda pesan dan mengamati waktunya, tetapi tidak bisa membaca atau memalsukannya, karena aplikasi memeriksa sendiri setiap kunci. Apa yang dijalankan server belum bisa dibuktikan.
