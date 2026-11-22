---
title: "Tanya jawab"
linkTitle: "Tanya jawab"
description: "Jawaban singkat tentang apa yang dilindungi Incognito Chat, apa yang tidak bisa dilindunginya, dan cara memakainya."
updated: "2026-11-22"
---

## Privasi

### Apakah orang yang saya kirimi pesan akan tahu siapa saya?

Tidak. Dia melihat label seperti **🦊 K3F9**, selalu sama setiap kali Anda menulis lewat tautannya, dan tidak ada keterangan lain tentang Anda: tidak ada nama, nama pengguna, atau nomor telepon Anda. Foto kehilangan data tersembunyi seperti lokasi sebelum dikirim, dan video kehilangan sebagian besarnya. Apa pun yang dikirim lewat **Berkas**, juga musik dan GIF, terkirim apa adanya, beserta nama berkasnya dan apa pun yang ada di dalamnya.

### Apakah tim Incognito Chat bisa membaca pesan saya?

Tidak. Pesan dan lampiran dienkripsi di perangkat Anda, dan hanya dua orang dalam obrolan itu yang bisa membacanya. Server menyimpan pesan, dalam keadaan terenkripsi, hanya sampai perangkat penerima mengambilnya, dan lampiran sampai dihapus: paling lama 30 hari untuk keduanya.

### Apakah server tahu siapa menulis kepada siapa?

Tidak ada yang disimpannya yang menunjukkan hal itu: pesan berpindah lewat kotak pesan acak, bukan lewat akun, dan dikirim tanpa login. Namun, siapa pun yang menjalankan server bisa saja mengamati lalu lintasnya secara langsung. Lihat [Seseorang yang memantau secara langsung](#live) di bawah.

### Apakah tim Incognito Chat bisa tahu akun Telegram mana yang memiliki sebuah tautan?

Saat ini bisa, jika kami memilih untuk melihatnya. Server menyimpan ID Telegram setiap akun dalam bentuk yang diacak, dan siapa pun yang memegang kunci server bisa mengetahui ID itu dari bentuk tersebut. Untuk sebagian besar tautan, hal ini tidak terlalu penting: tautan memang dibuat untuk dibagikan atau dikirim, jadi siapa pun yang mendapatkannya biasanya sudah tahu tautan itu milik siapa. Selain itu, mengetahui pemilik tautan tidak mengungkapkan siapa yang menulis kepada Anda, karena pesan dikirim tanpa login. Memindahkan server ke enclave, [yang sudah ada dalam rencana](/id/#roadmap), juga akan membuat kami sendiri tidak bisa lagi mengetahui pemilik tautan.

### Apa yang dilihat Telegram?

Bahwa Anda memakai bot, tautan mana yang Anda buka, dan kapan notifikasi “Pesan baru” dikirim. Bukan apa yang Anda tulis: pesan berjalan terenkripsi lewat server kami, tidak pernah lewat obrolan Telegram.

## Yang tidak bisa dilindungi

### Halaman palsu di dalam Telegram

Siapa pun yang mengendalikan bot menentukan halaman mana yang dibuka Telegram, dan Telegram tidak menyediakan cara untuk menguncinya. Halaman yang disajikan dari alamat mana pun selain [alamat resmi](/id/official/) tidak punya kunci Anda sama sekali, jadi halaman itu tidak bisa membaca pesan lama Anda, tetapi apa yang Anda ketik di dalamnya tidak aman. Jika suatu saat aplikasi meminta Anda menyiapkan lagi padahal Anda tidak memilihnya, jangan lakukan. Siapa pun bisa [memeriksa](/id/verify/) bahwa alamat resmi menyajikan persis kode yang dipublikasikan.

### Seseorang yang memantau secara langsung {#live}

Siapa pun yang menjalankan server, atau Amazon, penyedia hosting-nya, bisa saja memantau permintaan secara langsung dan mengaitkan orang-orang lewat kecocokan waktu dan alamat IP: sebuah pesan masuk, lalu notifikasi, lalu balasan atau tanda “Dibaca”. Telegram juga bisa saja mengaitkan orang-orang lewat kecocokan waktu. Salinan data yang tersimpan tidak menunjukkan hal ini, tetapi dengan kunci server, catatan yang disimpan sekitar sehari menunjukkan sebagian darinya. Bahkan dengan enclave, waktu dan alamat IP tetap akan terlihat.

### Perangkat Anda sendiri

Aplikasi ini berjalan di dalam Telegram, di ponsel atau komputer Anda. Siapa pun yang bisa memakai perangkat Anda saat tidak terkunci, atau malware di dalamnya, bisa membaca obrolan Anda, seperti pada aplikasi apa pun. Aplikasi Telegram sendiri juga bisa saja melakukannya. Dengan salinan penyimpanan aplikasi di perangkat Anda, misalnya salinan forensik ponsel Anda, seseorang bisa membuka obrolan Anda dan memakai akun Anda.

### Tangkapan layar

Orang yang Anda kirimi pesan selalu bisa menyalin atau memotret apa yang Anda kirim. Menghapus pesan di kedua sisi akan meminta aplikasi orang itu untuk menghapusnya, tetapi tidak bisa menjangkau salinan yang dia buat.

## Cara memakai

### Apakah saya perlu mendaftar?

Tidak. Untuk menulis lewat tautan seseorang, akun Telegram Anda sudah cukup: buka tautannya dan tulis pesan. Untuk saat ini, Anda perlu undangan untuk mendapatkan tautan sendiri.

### Bagaimana jika seseorang mengganggu saya?

Blokir dia: dia tidak diberi tahu, dan apa pun yang dia kirim tidak sampai. Orang yang menyiapkan akun baru akan muncul dengan label baru, jadi Anda mungkin perlu memblokirnya lagi. Anda juga bisa mengganti tautan Anda kapan saja; tautan lama langsung berhenti berfungsi.

### Bisakah saya menghapus pesan yang sudah saya kirim?

Bisa. Secara bawaan, pesan yang Anda hapus terhapus di kedua sisi, baik sudah dibaca maupun belum. Anda juga bisa menghapus seluruh obrolan di kedua sisi.

### Bisakah saya memakainya di ponsel atau komputer lain?

Hanya di satu perangkat dalam satu waktu. Menyiapkan akun di perangkat lain akan menggantikan akun Anda: Anda mendapat tautan baru, yang dibutuhkan orang untuk menghubungi Anda, dan obrolan lama Anda tetap ada di perangkat lama, tetapi hanya bisa dibaca. Tidak ada yang dipindahkan dan tidak ada yang dicadangkan, jadi jika ponsel Anda hilang, obrolan di dalamnya ikut hilang. Siapkan lagi di ponsel baru: itu langsung mengakhiri akun lama.

### Bagaimana cara menghapus akun saya?

Di tab **Tautan saya**, ketuk **Hapus akun**. Selama aplikasi tetap terbuka, server menghapus apa yang disimpannya untuk Anda dalam beberapa menit, lalu aplikasi menghapus obrolan dan kunci Anda dari perangkat ini. Lampiran yang Anda kirim tetap bisa diambil oleh penerimanya sampai kedaluwarsa, dalam waktu 30 hari.

### Berapa lama data disimpan?

Di server: pesan terenkripsi sampai perangkat Anda menerimanya, lampiran sampai dihapus, paling lama 30 hari untuk keduanya. Akun Anda (termasuk tautan Anda, ID Telegram yang diacak, dan bulan terakhir Anda membuka aplikasi) tetap ada sampai Anda menghapusnya, atau sampai aplikasi tidak dibuka selama 12 bulan. Di perangkat Anda: obrolan Anda, sampai Anda menghapusnya. Anda memilih berapa lama lampiran disimpan (selamanya, sebulan, atau seminggu) di **Data dan penyimpanan**.

## Tentang proyek ini

### Apakah gratis? Siapa yang membiayainya?

Gratis, tanpa iklan dan tanpa pelacak, dan dibiayai oleh donasi. Incognito Chat adalah perangkat lunak bebas dengan lisensi AGPL yang dibangun secara terbuka: [kodenya](https://github.com/{{< param "codeRepo" >}}) dan [situs ini](https://github.com/{{< param "siteRepo" >}}) ada di GitHub.

### Bagaimana saya bisa memeriksa semua ini?

Anda tidak perlu percaya begitu saja pada kata-kata kami. Halaman [Verifikasi](/id/verify/) menunjukkan cara siapa pun bisa memeriksa aplikasi ini, dan halaman [Status](/id/status/) menampilkan pemeriksaan otomatis terbaru. Detailnya ada di [model keamanan](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/security.md) dan daftar [apa saja yang disimpan perangkat lunak ini](https://github.com/{{< param "codeRepo" >}}/blob/main/docs/data.md) (keduanya dalam bahasa Inggris).

### Saya menemukan masalah keamanan

Mohon beri tahu kami secara pribadi lebih dulu: lihat [Keamanan](/id/security/).
