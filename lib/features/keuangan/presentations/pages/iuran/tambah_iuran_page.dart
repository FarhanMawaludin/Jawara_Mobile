import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../features/pengaturan/presentation/providers/log_activity_providers.dart';
import '../../providers/tagihiuran/tagihiuran_providers.dart';
import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';

class TambahIuranPage extends ConsumerStatefulWidget {
  const TambahIuranPage({super.key});

  @override
  ConsumerState<TambahIuranPage> createState() => _TambahIuranPageState();
}

class _TambahIuranPageState extends ConsumerState<TambahIuranPage> {
  int? selectedKategoriId;
  final TextEditingController namaIuranController = TextEditingController();

  void resetForm() {
    setState(() {
      selectedKategoriId = null;
      namaIuranController.clear();
    });
  }

 Future<void> simpanIuran() async {
  if (selectedKategoriId == null || namaIuranController.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua form wajib diisi")),
    );
    return;
  }

  try {
    // Gunakan notifier untuk create
    await ref.read(tagihIuranNotifierProvider.notifier).create(
      kategoriId: selectedKategoriId!,
      nama: namaIuranController.text.trim(),
      jumlah: 0, // atau dari input
    );

    // Log activity
    await ref
        .read(logActivityNotifierProvider.notifier)
        .createLogWithCurrentUser(
            title: 'Menambahkan iuran: ${namaIuranController.text.trim()}');

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Iuran berhasil disimpan untuk semua keluarga!")),
    );
    context.pop();

  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal menyimpan: $e")),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final kategoriState = ref.watch(kategoriIuranNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tagih Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ==========================
            /// DROPDOWN KATEGORI IURAN (dari database)
            /// ==========================
            const Text(
              "Kategori Iuran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            kategoriState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, st) => Text("Error: $error"),
              data: (kategoriList) => DropdownButtonFormField<int>(
                value: selectedKategoriId,
                items: kategoriList.map((kat) {
                  return DropdownMenuItem(
                    value: kat.id,
                    child: Text(kat.namaKategori),
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedKategoriId = value),
                decoration: InputDecoration(
                  hintText: "Pilih Kategori Iuran",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// ==========================
            /// FORM NAMA IURAN
            /// ==========================
            const Text(
              "Nama Iuran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: namaIuranController,
              decoration: InputDecoration(
                hintText: "Masukkan Nama Iuran",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),

            const SizedBox(height: 22),

            /// ==========================
            /// BUTTON SIMPAN
            /// ==========================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: simpanIuran,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A3FFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 12),

            /// ==========================
            /// BUTTON RESET
            /// ==========================
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: resetForm,
                child: const Text(
                  "Reset",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
