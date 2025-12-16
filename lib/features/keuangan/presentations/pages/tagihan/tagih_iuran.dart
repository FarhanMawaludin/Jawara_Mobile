import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/tagihiuran/tagihiuran_providers.dart';
import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';

class TagihIuran extends ConsumerStatefulWidget {
  const TagihIuran({super.key});

  @override
  ConsumerState<TagihIuran> createState() => _TagihIuranState();
}

class _TagihIuranState extends ConsumerState<TagihIuran> {
  int? selectedKategoriId;
  final TextEditingController namaIuranController = TextEditingController();
  final TextEditingController nominalIuranController = TextEditingController(); // ✅ Input manual

  void resetForm() {
    setState(() {
      selectedKategoriId = null;
      namaIuranController.clear();
      nominalIuranController.clear();
    });
  }

  Future<void> simpanIuran() async {
    // ✅ Validasi semua field
    if (selectedKategoriId == null || 
        namaIuranController. text. isEmpty || 
        nominalIuranController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua form wajib diisi")),
      );
      return;
    }

    try {
      // ✅ Parse nominal dari input user
      final jumlah = int.tryParse(nominalIuranController.text. trim());
      if (jumlah == null || jumlah <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nominal harus berupa angka valid")),
        );
        return;
      }

      // ✅ Create tagihan untuk semua keluarga
      await ref.read(tagihIuranNotifierProvider.notifier).create(
        kategoriId:  selectedKategoriId!,
        nama: namaIuranController.text.trim(),
        jumlah: jumlah, // ✅ Nominal dari input user
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Iuran berhasil disimpan untuk semua keluarga! "),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Gagal menyimpan:  $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    namaIuranController.dispose();
    nominalIuranController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final kategoriState = ref.watch(kategoriIuranNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tagih Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed:  () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment. start,
          children: [
            /// ==========================
            /// DROPDOWN KATEGORI IURAN
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
                    child: Text(kat.namaKategori), // ✅ Hanya tampilkan nama
                  );
                }).toList(),
                onChanged: (value) => setState(() => selectedKategoriId = value),
                decoration: InputDecoration(
                  hintText: "Pilih Kategori Iuran",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: 
                      const EdgeInsets. symmetric(horizontal: 12, vertical: 14),
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
              controller:  namaIuranController,
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
            /// NOMINAL IURAN (INPUT MANUAL)
            /// ==========================
            const Text(
              "Nominal Iuran",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: nominalIuranController, // ✅ Input manual dari user
              keyboardType: TextInputType.number, // ✅ Keyboard angka
              decoration: InputDecoration(
                hintText: "Masukkan Nominal Iuran",
                prefixText: "Rp ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius. circular(10),
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
              width:  double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: simpanIuran,
                style: ElevatedButton. styleFrom(
                  backgroundColor:  const Color(0xFF7A3FFF),
                  shape:  RoundedRectangleBorder(
                    borderRadius:  BorderRadius.circular(10),
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
              width:  double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: resetForm,
                child:  const Text(
                  "Reset",
                  style: TextStyle(fontSize: 16, color:  Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}