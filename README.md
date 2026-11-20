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

1. **Endpoint REST API (Django):** situs web menyediakan endpoint JSON melalui Django REST Framework (DRF), contoh `https://muhammad-hasbi52-salink.pws.cs.ui.ac.id/saling-beli/json/`.
2. **Pemanggilan asinkron (Flutter):** aplikasi mengirim request HTTP (`http.get`, `http.post`) secara asinkron dengan header JSON dan Authorization Token.
3. **Autentikasi Berbasis Token:** pengguna melakukan login melalui endpoint token, kemudian token disimpan di penyimpanan lokal aplikasi (`SharedPreferences`) dan dikirimkan pada header setiap request yang membutuhkan autentikasi: `Authorization: Token <token>`.
4. **Parsing JSON ke model Dart:** respons di-decode dengan `dart:convert` lalu dipetakan ke objek model (misalnya `ItemListing.fromJson` atau `BorrowItem`).
5. **Penyajian data di UI:** data ditampilkan secara reaktif dengan `FutureBuilder`, `ListView.builder`, dan `GridView.builder`.
6. **Kirim data (mutasi):** formulir mengirim payload JSON melalui HTTP POST ke endpoint Django terkait.

### Daftar Endpoint

| Modul | Method | Endpoint | Keterangan |
| --- | --- | --- | --- |
| Saling Beli | GET | `/saling-beli/json/` | Mengambil seluruh katalog barang aktif |
| Saling Beli | POST | `/saling-beli/create/` | Menambah barang baru via REST API |
| Saling Beli | GET | `/saling-beli/<id>/` | Mengambil data detail satu barang preloved |
| Saling Pinjam | GET | `/saling-pinjam/json/` | Mengambil daftar barang yang dapat dipinjam |
| Saling Pinjam | POST | `/saling-pinjam/create/` | Mendaftarkan barang pinjaman baru |
| Saling Pinjam | POST | `/saling-pinjam/<id>/request/` | Mengajukan peminjaman barang ke pemilik |
| Saling Bagi | GET | `/saling-bagi/json/` | Mengambil daftar makanan berlebih yang tersedia |
| Saling Bagi | POST | `/saling-bagi/tambah/` | Menambahkan makanan berlebih yang dibagikan |
| Saling Nebeng | GET | `/saling-nebeng/json/` | Mengambil daftar jadwal tebengan aktif |
| Saling Nebeng | POST | `/saling-nebeng/nebeng/tawarkan/` | Mempublikasikan jadwal tebengan baru |
| Autentikasi | POST | `/api/v1/auth/login/` | Autentikasi login pengguna dan penerbitan Token |
| Autentikasi | POST | `/api/v1/auth/register/` | Pendaftaran akun pengguna baru via REST API |
| Autentikasi | GET | `/api/v1/auth/profile/` | Mengambil data profil pengguna yang sedang login |
| Autentikasi | POST | `/api/v1/auth/logout/` | Menghapus token autentikasi di server |

---

## 6. Tautan Desain & Deployment

- **Desain Figma:** [SaLink UI/UX Wireframe](https://www.figma.com/design/mLX7a6qFC62AiaaPumui8N/SaLink)
- **APK (GitHub Release):** *(ditambahkan setelah rilis)*
- **APK (Bitrise):** *(ditambahkan setelah rilis)*
- **Video promosi (bonus):** *(opsional)*