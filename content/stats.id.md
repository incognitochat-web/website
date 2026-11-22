---
title: "Statistik"
linkTitle: "Statistik"
description: "Seberapa banyak layanan ini dipakai, bulan demi bulan, dan berapa biaya menjalankannya. Angka sebenarnya."
---

{{< stats >}}

## Apa yang dihitung

- **Akun yang disiapkan**: penyiapan yang berhasil, termasuk menyiapkan lagi di perangkat baru dan penyiapan yang dicoba ulang karena jawaban server tidak sampai.
- **Pesan terkirim**: pesan yang ditulis orang, berisi teks, lampiran, atau stiker. Tidak termasuk tanda dibaca, reaksi, edit, hapus, atau pembaruan kunci, yang ditandai aplikasi sebagai senyap (tanpa notifikasi). Pengiriman ke tautan yang sudah tidak berfungsi juga dihitung, karena server sengaja menjawabnya dengan cara yang sama. Aplikasi yang dimodifikasi bisa saja menandai pesan sebagai senyap, atau mengirim lebih banyak, sebatas yang dimungkinkan token-tokennya.
- **Media**: ukuran lampiran yang dibayar, dengan padding yang sama seperti yang diterapkan aplikasi pada setiap berkas (dibulatkan ke atas ke pangkat dua hingga 1 MiB, lalu ke MiB utuh), jadi sedikit di atas ukuran aslinya. Yang dihitung adalah unggahan yang dibayar, bukan yang selesai, dan semua jenis berkas sekaligus: server tidak bisa membedakan foto dari pesan suara.
- **Biaya**: tagihan AWS untuk menjalankan layanan setiap hari, sebelum dipotong kredit apa pun: produksi per layanan (empat yang terbesar disebut namanya), dan lingkungan uji sebagai satu total. AWS masih merevisi angka hari-hari terakhir untuk beberapa waktu, dan angka bulan ini adalah perkiraannya.

Hanya hitungan dan jumlah: tidak ada apa pun di sini, atau di sumber hitungan ini, yang menunjukkan siapa melakukan apa.

## Asal angka-angka ini

- Server aplikasi menghitung sekali per menit, dan AWS (CloudWatch) menjumlahkan hitungannya per jam. [Tugas terjadwal](https://github.com/{{< param "siteRepo" >}}/blob/main/.github/workflows/stats.yml) di repositori publik situs ini membacanya setiap jam, dan biayanya sekali sehari, dengan peran akses yang hanya bisa membaca metrik dan biaya.
- Hitungan setiap jam diberi waktu sesuai kapan server menuliskannya, yang bisa jauh lebih lambat pada server yang sepi: server menulis hitungan satu menit bersama permintaan berikutnya yang ia tangani, atau saat ia berhenti. Jadi satu jam bisa memuat hitungan dari jam-jam sebelumnya. Setiap proses membaca ulang 7 hari terakhir, jadi proses yang terlambat atau terlewat hingga seminggu tidak meninggalkan celah.
- Tugas itu menyimpan setiap angka yang dibacanya di [cabang `data`](https://github.com/{{< param "siteRepo" >}}/tree/data/stats) repositori, jadi riwayatnya publik, dan menandatangani setiap berkas yang ditulisnya dengan Sigstore:

  ```shell
  gh attestation verify <file> --repo {{< param "siteRepo" >}} \
    --cert-identity https://github.com/{{< param "siteRepo" >}}/.github/workflows/stats.yml@refs/heads/main
  ```

- Itu menunjukkan bahwa sebuah angka melewati tugas publik ini tanpa diubah. Itu tidak bisa menunjukkan bahwa data yang disimpan AWS benar: siapa pun yang mengelola akun AWS bisa saja mengubahnya. Setelah server berjalan di enclave teratestasi (lihat rencana ke depan di [beranda](/id/)), server itu sendiri yang akan menghitung dan menandatangani angka-angka ini.
