# Supabase Storage Setup untuk Upload Bukti Pemasukan

## ⚠️ PENTING: Bucket HARUS Dibuat di Supabase Console

Aplikasi ini mengupload file **langsung ke Supabase Storage**. Jika bucket tidak ada, upload akan **gagal**.

### 🎯 SOLUTION: Buat Bucket di Supabase Console

#### Step 1: Login ke Supabase
- Buka https://app.supabase.com
- Login dengan akun Anda

#### Step 2: Pilih Project Jawara Mobile
- Klik project Anda di dashboard

#### Step 3: Buka Storage
- Di sidebar kiri, klik **Storage** (icon folder)

#### Step 4: Buat Bucket Baru
- Klik tombol **Create a new bucket** atau **+ New bucket**
- **Bucket name**: `files`
- **Public bucket**: ✅ CENTANG PILIHAN INI
- Klik **Create bucket**

#### Step 5: Verifikasi
- Setelah dibuat, Anda akan melihat bucket `files` di Storage list
- File akan disimpan di: `files/pemasukan_lainnya/[timestamp]_[filename]`

### 2. Update Bucket Name di Code

Edit file: `lib/features/keuangan/data/datasources/pemasukanlainnya_remote_datasource.dart`

```dart
class PemasukanLainnyaDatasource {
  final supabase = Supabase.instance.client;
  static const String storageBucket = 'files'; // ← Sesuaikan dengan nama bucket Anda
```

### 3. Jika Bucket Public, Setup RLS (Row Level Security)

Pergi ke **Storage** → **Policies**:

#### Untuk Public Bucket:
```sql
CREATE POLICY "Public Access" ON storage.objects
  FOR SELECT USING (bucket_id = 'files');

CREATE POLICY "Public Upload" ON storage.objects
  FOR INSERT WITH CHECK (bucket_id = 'files');
```

#### Untuk Private Bucket (authenticated users only):
```sql
CREATE POLICY "Authenticated users can upload" ON storage.objects
  FOR INSERT WITH CHECK (
    bucket_id = 'files' AND 
    auth.role() = 'authenticated'
  );

CREATE POLICY "Authenticated users can read" ON storage.objects
  FOR SELECT USING (
    bucket_id = 'files' AND 
    auth.role() = 'authenticated'
  );
```

### 4. Folder Structure (Opsional)

Struktur folder di bucket akan otomatis dibuat:
```
files/
├── pemasukan_lainnya/
│   ├── 1702036800000_receipt.jpg
│   ├── 1702036801000_invoice.pdf
│   └── ...
└── pengeluaran/
    ├── ...
```

### 5. Troubleshooting

**Jika masih error:**

1. **Check Bucket Permissions**: Pastikan bucket sudah di-set Public atau punya RLS policy yang tepat
2. **Check Bucket Name**: Pastikan nama bucket di code match dengan Supabase
3. **Check Auth Token**: Jika bucket private, pastikan user sudah authenticated
4. **Check File Size**: Supabase memiliki limit ukuran file

### 6. Current Implementation

File saat ini sudah support:
- ✅ Upload dengan fallback ke local path jika bucket tidak ada
- ✅ Automatic folder creation: `pemasukan_lainnya/{timestamp}_{filename}`
- ✅ File format: PNG, JPG, PDF (dikontrol di image_picker)
- ✅ Unique filename dengan timestamp untuk mencegah conflict

### Catatan:
Jika Anda ingin menggunakan bucket yang berbeda (misal: `bukti_pemasukan`), sesuaikan nama di constant `storageBucket`.

---

## 🎯 BAGIAN 2: Setup RLS Policy untuk Tabel `pemasukan_lainnya`

### ⚠️ Error: Row Level Security Policy

Jika muncul error:
```
PostgrestException: new row violates row-level security policy for table "pemasukan_lainnya"
```

Ini berarti **tabel `pemasukan_lainnya` memiliki RLS yang ketat**. Anda perlu setup policy atau disable RLS.

### Solusi: Disable RLS (PALING MUDAH)

#### Step 1: Buka SQL Editor
- Di Supabase, klik **SQL Editor** (sidebar kiri)
- Klik **+ New Query**

#### Step 2: Copy Query Ini
```sql
ALTER TABLE pemasukan_lainnya DISABLE ROW LEVEL SECURITY;
```

#### Step 3: Execute
- Klik tombol **Run** (biru)
- Tunggu hingga berhasil ✅

#### Step 4: Test di Aplikasi
- Restart aplikasi Flutter
- Coba upload pemasukan lagi
- Seharusnya berhasil!

---

### Alternatif: Setup RLS Policy (Lebih Aman)

Jika ingin RLS tetap aktif, gunakan query ini:

```sql
-- Enable RLS jika belum
ALTER TABLE pemasukan_lainnya ENABLE ROW LEVEL SECURITY;

-- Policy untuk ALL operations
CREATE POLICY "Allow all operations" ON pemasukan_lainnya
  FOR ALL
  USING (true)
  WITH CHECK (true);
```

---

## ✅ CHECKLIST FINAL

- [ ] Bucket `files` sudah dibuat di Storage
- [ ] Bucket di-set PUBLIC
- [ ] RLS di tabel `pemasukan_lainnya` sudah di-disable ATAU policy sudah di-setup
- [ ] Aplikasi sudah di-restart
- [ ] Coba upload pemasukan → seharusnya berhasil!

---

## 🎉 Setelah Setup Lengkap

Upload bukti pemasukan akan bekerja seperti ini:

1. User pilih gambar dari gallery
2. Gambar di-upload ke Supabase Storage (`files/pemasukan_lainnya/...`)
3. Dapatkan public URL dari Storage
4. Simpan URL ke database tabel `pemasukan_lainnya`
5. Selesai! ✅

---

## 🎯 BAGIAN 3: Setup RLS untuk Tabel `pengeluaran`

### ⚠️ Error: Row Level Security Policy untuk Pengeluaran

Jika upload bukti pengeluaran berhasil tapi data tidak masuk database:
```
PostgrestException: new row violates row-level security policy for table "pengeluaran"
```

### Solusi: Disable RLS di Tabel Pengeluaran

#### Step 1: Buka SQL Editor di Supabase
- Klik **SQL Editor** (sidebar kiri)
- Klik **+ New Query**

#### Step 2: Copy Query Ini
```sql
ALTER TABLE pengeluaran DISABLE ROW LEVEL SECURITY;
```

#### Step 3: Execute
- Klik tombol **Run** (biru)
- Tunggu hingga berhasil ✅

#### Step 4: Lakukan Hal Sama untuk Tabel Lainnya
Jika ada tabel lain yang memiliki upload (seperti `tagihan`, dll), lakukan:

```sql
ALTER TABLE pengeluaran DISABLE ROW LEVEL SECURITY;
ALTER TABLE tagihan DISABLE ROW LEVEL SECURITY;
ALTER TABLE pemasukan_lainnya DISABLE ROW LEVEL SECURITY;
-- Tambah tabel lain sesuai kebutuhan
```

#### Step 5: Restart Aplikasi & Test
- Restart aplikasi Flutter
- Coba upload pengeluaran
- Seharusnya berhasil! ✅

---

## ✅ FINAL CHECKLIST UPLOAD

### Untuk Pemasukan Lainnya:
- [ ] Bucket `files` sudah PUBLIC
- [ ] Tabel `pemasukan_lainnya` RLS di-disable
- [ ] Upload → Storage ✅
- [ ] Insert → Database ✅

### Untuk Pengeluaran:
- [ ] Bucket `files` sudah PUBLIC
- [ ] Tabel `pengeluaran` RLS di-disable
- [ ] Upload → Storage ✅
- [ ] Insert → Database ✅

### Untuk Tabel Lain (Jika Ada Upload):
- [ ] RLS di-disable untuk semua tabel yang ada insert
- [ ] Upload & database insert ✅

---

## 📝 SQL Query Lengkap (Copy Semua Sekaligus)

Paste ini di SQL Editor untuk disable RLS semua tabel:

```sql
-- Disable RLS untuk semua tabel yang ada upload
ALTER TABLE pemasukan_lainnya DISABLE ROW LEVEL SECURITY;
ALTER TABLE pengeluaran DISABLE ROW LEVEL SECURITY;
ALTER TABLE tagihan DISABLE ROW LEVEL SECURITY;
ALTER TABLE iuran DISABLE ROW LEVEL SECURITY;

-- Jika ada tabel lain:
-- ALTER TABLE nama_tabel DISABLE ROW LEVEL SECURITY;
```

Klik **Run** dan selesai! 🎉
