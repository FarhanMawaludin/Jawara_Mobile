import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/kegiatan_form_provider.dart';
import 'widgets/form_tambah/nama_kegiatan.dart';
import 'widgets/form_tambah/tanggal_kegiatan.dart';
import 'widgets/form_tambah/lokasi.dart';
import 'widgets/form_tambah/penganggunjawab.dart';
import 'widgets/form_tambah/kategori_kegiatan.dart';
import 'widgets/form_tambah/deskripsi_kegiatan.dart';
import 'widgets/form_tambah/form_anggaran.dart'; // ✅ TAMBAHKAN
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class TambahKegiatanPage extends ConsumerStatefulWidget {
  const TambahKegiatanPage({super.key});

  @override
  ConsumerState<TambahKegiatanPage> createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends ConsumerState<TambahKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF6C63FF);

  // Konfirmasi saat keluar dari halaman
  Future<bool> _onWillPop() async {
    final formState = ref.read(kegiatanFormProvider);

    if (formState.isEmpty) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan?'),
        content: const Text(
          'Data yang Anda isi belum disimpan. Apakah Anda yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Lanjut Mengisi',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(kegiatanFormProvider.notifier).reset();
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  // Submit form tambah kegiatan
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Tampilkan loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Submit form
      final result = await ref.read(kegiatanFormProvider.notifier).submitForm();

      // Tutup loading
      if (mounted) Navigator.pop(context);

      // Tampilkan hasil
      if (result['success']) {
        // BUAT LOG ACTIVITY
        final namaKegiatan = ref.read(kegiatanFormProvider).namaKegiatan;
        final anggaran = ref.read(kegiatanFormProvider).anggaran; // ✅ AMBIL anggaran
        
        // ✅ Log dengan info anggaran jika ada
        final logTitle = anggaran > 0
            ? 'Menambahkan kegiatan baru: $namaKegiatan (Anggaran: Rp ${anggaran.toStringAsFixed(0)})'
            : 'Menambahkan kegiatan baru: $namaKegiatan';
            
        await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
          title: logTitle,
        );

        // ✅ Tampilkan pesan dengan info pengeluaran jika ada
        final successMessage = result['pengeluaran_created'] == true
            ? 'Kegiatan dan pengeluaran berhasil ditambahkan'
            : 'Kegiatan berhasil ditambahkan';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Gagal menyimpan kegiatan',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(kegiatanFormProvider); // ✅ Watch state untuk anggaran

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Tambah Kegiatan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Kegiatan Field
                  NamaKegiatanField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // Tanggal Kegiatan Field
                  TanggalKegiatanField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // Lokasi Field
                  LokasiKegiatanField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // Penanggung Jawab Field
                  PenanggungJawabField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // Kategori Dropdown
                  KategoriKegiatanDropdown(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // Deskripsi Field
                  DeskripsiKegiatanField(primaryColor: _primaryColor),
                  const SizedBox(height: 20),

                  // ✅ TAMBAHKAN Form Anggaran
                  AnggaranKegiatanField(
                    anggaran: formState.anggaran,
                    onChanged: (value) {
                      ref.read(kegiatanFormProvider.notifier).updateAnggaran(value);
                    },
                  ),
                  const SizedBox(height: 40),

                  // Tombol Submit
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: _primaryColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Simpan Kegiatan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
