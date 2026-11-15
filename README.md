# SaLink Mobile

> Aplikasi mobile SaLink: pertukaran dan pemanfaatan kembali sumber daya di lingkungan kampus Universitas Indonesia.

Aplikasi ini dibangun menggunakan **Flutter** untuk Proyek Akhir Semester **Pemrograman Berbasis Platform (CSGE602022)** Gasal 2026/2027, Fakultas Ilmu Komputer Universitas Indonesia. Data diambil dari web service **Django REST Framework** pada situs web SaLink (Proyek Tengah Semester).

---

## 1. Anggota Kelompok

| Nama Lengkap | NPM |
| --- | --- |
| KEIZORA JELITA WOHINGATI | 2506597510 |
| HADYASALHA ALINA ANINDYA | 2506620406 |
| MUHAMMAD HASBI ASSIDDIQ | 2506624360 |
| BALQIS RAIHANA | 2506625981 |
| BAGAS MAHENDRA SRIKASTA | 2506656551 |

---

## 2. Deskripsi Aplikasi

**SaLink Mobile** memfasilitasi pertukaran dan pemanfaatan kembali sumber daya di lingkungan kampus UI. Mahasiswa dapat:

- Melihat katalog dan bertransaksi barang bekas layak pakai (*preloved*) maupun hibah gratis.
- Mengajukan peminjaman alat perkuliahan atau perlengkapan praktikum/kegiatan.
- Mengklaim makanan berlebih yang masih layak konsumsi untuk mengurangi pemborosan makanan.
- Melihat jadwal dan mencari tumpangan (tebengan) di sekitar kampus UI.
- Mengakses akun mahasiswa melalui autentikasi terpusat yang terintegrasi dengan situs web Django.

---

## 3. Daftar Modul & Pembagian Kerja

### KEIZORA JELITA WOHINGATI: User Page / Main Page / Akun Bersama (`user_page` / `main`)
- Halaman utama (beranda) dan navigasi drawer (`LeftDrawer`).
- Manajemen sesi login dan registrasi akun mahasiswa menggunakan `pbp_django_auth`.

### HADYASALHA ALINA ANINDYA: Saling Nebeng / Transportasi Bersama (`saling_tebeng`)
- Daftar tawaran tebengan aktif (rute asal, tujuan kampus, kapasitas kursi).
- Formulir untuk menawarkan tebengan atau bergabung ke jadwal tebengan.

### MUHAMMAD HASBI ASSIDDIQ: Saling Bagi / Makanan Berlebih (`saling_bagi`)
- Etalase makanan berlebih yang dibagikan oleh mahasiswa.
- Formulir pengajuan janji temu pengambilan makanan.

### BALQIS RAIHANA: Saling Beli / Preloved & Hibah (`saling_beli`)
- Daftar katalog barang bekas dan hibah melalui HTTP request ke endpoint DRF `/saling-beli/json/`.
- Pemetaan respons JSON ke model Dart (`ItemListing`), ditampilkan dengan `FutureBuilder` dan `ListView`.
- Kartu barang (foto/placeholder, nama, harga/hibah, kondisi, lokasi) dan penanganan galat jaringan.

### BAGAS MAHENDRA SRIKASTA: Saling Pinjam / Alat & Barang (`saling_pinjam`)
- Daftar barang yang tersedia untuk dipinjam beserta status ketersediaannya.
- Formulir permohonan pinjam alat/barang ke pemilik barang.

---

## 4. Peran / Aktor Pengguna

| Aktor | Hak Akses |
| --- | --- |
| **Pengguna Tamu (Guest)** | Membuka aplikasi dan menjelajah seluruh katalog (barang, makanan, jadwal tebengan, barang pinjam) tanpa login. |
| **Mahasiswa Terautentikasi** | Semua akses tamu, ditambah aksi yang mengubah/mengirim data: mengajukan penawaran barang, mengklaim makanan, meminjam alat, menawarkan/memesan tebengan, dan mengelola profil. |

---

## 5. Alur Integrasi Data (Web Service Django REST Framework)

Data tidak disimpan statis di aplikasi, melainkan diambil dari backend Django yang di-deploy di PWS.

1. **Endpoint REST API (Django):** situs web menyediakan endpoint JSON melalui DRF, contoh `https://muhammad-hasbi52-salink.pws.cs.ui.ac.id/saling-beli/json/`.
2. **Pemanggilan asinkron (Flutter):** aplikasi mengirim request HTTP (`http.get` / `CookieRequest`) secara asinkron.
3. **Parsing JSON ke model Dart:** respons di-decode dengan `dart:convert` lalu dipetakan ke objek model (misalnya `ItemListing.fromJson`).
4. **Penyajian data di UI:** data ditampilkan secara reaktif dengan `FutureBuilder`, `ListView.builder`, dan `Card`.
5. **Kirim data (mutasi):** formulir mengirim payload JSON melalui HTTP POST, dengan autentikasi sesi berbasis cookie, ke endpoint Django terkait.

### Daftar Endpoint

| Modul | Method | Endpoint | Keterangan |
| --- | --- | --- | --- |
| Saling Beli | GET | `/saling-beli/json/` | Mengambil seluruh katalog barang aktif |
| Saling Beli | POST | `/saling-beli/create/` | Menambah barang baru via REST API |
| Saling Pinjam | GET | `/saling-pinjam/` | Mengambil daftar barang yang dapat dipinjam |
| Saling Pinjam | POST | `/saling-pinjam/create/` | Mendaftarkan barang pinjaman baru |
| Saling Bagi | GET | `/saling-bagi/` | Mengambil daftar makanan berlebih yang tersedia |
| Saling Bagi | POST | `/saling-bagi/tambah/` | Menambahkan makanan berlebih yang dibagikan |
| Saling Nebeng | GET | `/saling-nebeng/` | Mengambil daftar jadwal tebengan aktif |
| Saling Nebeng | POST | `/saling-nebeng/nebeng/tawarkan/` | Mempublikasikan jadwal tebengan baru |
| Autentikasi | POST | `/akun/login/` | Autentikasi login pengguna dan inisialisasi sesi |
| Autentikasi | POST | `/akun/register/` | Pendaftaran akun pengguna baru |

---

## 6. Tautan Desain & Deployment

- **Desain Figma:** [SaLink UI/UX Wireframe](#)
- **APK (GitHub Release):** *(ditambahkan setelah rilis)*
- **APK (Bitrise):** *(ditambahkan setelah rilis)*
- **Video promosi (bonus):** *(opsional)*