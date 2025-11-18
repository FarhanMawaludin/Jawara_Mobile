# Jawara Mobile App

Jawara Mobile adalah aplikasi manajemen warga untuk sebuah perumahan.  
Aplikasi ini mempermudah pengelolaan data warga, rumah, riwayat penghuni, mutasi keluarga, dan berbagai kebutuhan administrasi lingkungan.

Aplikasi ini dibuat menggunakan **Flutter** dan terintegrasi dengan **Supabase** sebagai backend untuk autentikasi, database, dan manajemen data.

---

## Fitur Utama

- **Manajemen Warga**
  - Tambah, edit, dan lihat data warga
  - Informasi lengkap seperti NIK, alamat, tanggal lahir, dan status keluarga

- **Manajemen Rumah**
  - Data rumah per blok dan nomor
  - Relasi antara rumah dan penghuni

- **Riwayat Penghuni**
  - Tracking mutasi masuk/keluar warga
  - Histori perpindahan (family movement log)

- **Manajemen Keluarga**
  - Data kepala keluarga
  - Anggota keluarga
  - Riwayat perubahan keluarga

- **Autentikasi Supabase**
  - Login, register, dan sign out
  - Role-based access (admin / warga)

- **Notifikasi & Informasi Lingkungan** 
  - Pengumuman, kegiatan, dan berita perumahan

---

## 🛠️ Teknologi yang Digunakan

- **Flutter 3.x**
- **Supabase (Auth, Database, Storage)**
- Clean Architecture (presentation, domain, data)
- State management (Provider / Riverpod / Bloc — sesuaikan)
- Integration & Unit Testing

---

## 📦 Instalasi

Clone project:

```bash
git clone https://github.com/FarhanMawaludin/Jawara_Mobile.git
cd jawaramobile
