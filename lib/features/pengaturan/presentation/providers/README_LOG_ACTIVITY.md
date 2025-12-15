# Cara Menggunakan Log Activity Provider

Provider log activity telah dilengkapi dengan function untuk membuat log secara real-time. Setiap kali pengguna melakukan aksi di aplikasi, Anda bisa langsung merekam aktivitas tersebut.

## Import yang Diperlukan

```dart
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
```

## Cara Penggunaan

### 1. Dengan User ID Manual

Gunakan ini jika Anda sudah memiliki user ID yang ingin dicatat:

```dart
// Di dalam widget atau provider
await ref.read(logActivityNotifierProvider.notifier).createLog(
  title: 'Menambahkan warga baru: John Doe',
  userId: 'user-id-123', // opsional
);
```

### 2. Dengan User ID Otomatis (Recommended)

Gunakan ini untuk mendapatkan user ID otomatis dari session yang sedang login:

```dart
// Di dalam widget atau provider
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Mengubah data rumah: Blok A No. 12',
);
```

## Contoh Implementasi Lengkap

### Contoh 1: Di Form Submit (Widget)

```dart
class TambahWargaPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () async {
        try {
          // Simpan data warga
          await saveWarga();
          
          // Buat log activity
          await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
            title: 'Menambahkan warga baru: ${namaController.text}',
          );
          
          // Tampilkan notifikasi sukses
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Berhasil menambahkan warga')),
          );
        } catch (e) {
          // Handle error
          print('Error: $e');
        }
      },
      child: Text('Simpan'),
    );
  }
}
```

### Contoh 2: Di Provider/Notifier

```dart
class WargaFormNotifier extends StateNotifier<WargaFormState> {
  final Ref ref;
  
  WargaFormNotifier(this.ref) : super(WargaFormState());

  Future<void> submitWarga() async {
    try {
      // Simpan data warga ke database
      await client.from('warga').insert({
        'nama': state.nama,
        // ... field lainnya
      });
      
      // Buat log activity
      await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
        title: 'Menambahkan warga baru: ${state.nama}',
      );
      
    } catch (e) {
      throw Exception('Gagal menyimpan warga: $e');
    }
  }
}
```

### Contoh 3: Berbagai Jenis Aktivitas

```dart
// Untuk tambah data
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Menambahkan kegiatan baru: Gotong Royong',
);

// Untuk edit data
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Mengubah data warga: ${wargaName}',
);

// Untuk hapus data
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Menghapus rumah: Blok ${blok} No. ${nomorRumah}',
);

// Untuk approval/verifikasi
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Menyetujui registrasi dari: Keluarga ${namaKeluarga}',
);

// Untuk broadcast
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Membuat broadcast baru: ${judulBroadcast}',
);

// Untuk transaksi keuangan
await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
  title: 'Menambahkan pengeluaran: ${kategori} sebesar Rp. ${nominal}',
);
```

## Error Handling

Provider akan melempar exception jika terjadi error. Pastikan untuk wrap dalam try-catch:

```dart
try {
  await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
    title: 'Aktivitas pengguna',
  );
} catch (e) {
  // Handle error sesuai kebutuhan
  print('Error membuat log: $e');
  // Atau tampilkan pesan error ke user
}
```

## State Management

Provider menggunakan `AsyncValue`, jadi Anda bisa mendengarkan state-nya:

```dart
// Mendengarkan perubahan state
ref.listen(logActivityNotifierProvider, (previous, next) {
  next.when(
    data: (_) => print('Log berhasil dibuat'),
    loading: () => print('Sedang membuat log...'),
    error: (error, stack) => print('Error: $error'),
  );
});
```

## Tips Penggunaan

1. **Gunakan deskripsi yang jelas**: Pastikan title yang Anda berikan deskriptif dan mudah dipahami
2. **Konsisten dengan format**: Ikuti pola yang sama untuk jenis aktivitas yang serupa
3. **Gunakan createLogWithCurrentUser()**: Lebih mudah dan otomatis mendapatkan user dari session
4. **Jangan lupa error handling**: Selalu wrap dalam try-catch untuk menghindari crash
5. **Log setelah operasi berhasil**: Buat log hanya setelah operasi utama berhasil dilakukan

## Format Penamaan Title yang Disarankan

- Tambah: "Menambahkan [entitas] baru: [nama/detail]"
- Edit: "Mengubah [entitas]: [nama/detail]"
- Hapus: "Menghapus [entitas]: [nama/detail]"
- Approval: "Menyetujui [entitas] dari: [nama/detail]"
- Broadcast: "Membuat broadcast baru: [judul]"
- Transaksi: "Menambahkan [jenis transaksi]: [kategori] sebesar [nominal]"
