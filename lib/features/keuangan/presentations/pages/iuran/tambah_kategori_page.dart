import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';
import '../../../data/models/kategoriiuran_model.dart';

class TambahKategoriIuranPage extends ConsumerStatefulWidget {
  const TambahKategoriIuranPage({super.key});

  @override
  ConsumerState<TambahKategoriIuranPage> createState() => _TambahKategoriIuranPageState();
}

class _TambahKategoriIuranPageState extends ConsumerState<TambahKategoriIuranPage> {
  final TextEditingController namaKategoriController = TextEditingController();
  final TextEditingController nominalController = TextEditingController();
  String? selectedKategoriIuran;

  final List<String> kategoriIuranOptions = [
    "Iuran Bulanan",
    "Iuran Khusus",
    "Iuran Lainnya",
  ];

  void resetForm() {
    setState(() {
      namaKategoriController.clear();
      nominalController.clear();
      selectedKategoriIuran = null;
    });
  }

  Future<void> simpanKategori() async {
    if (namaKategoriController.text. isEmpty ||
        nominalController.text. isEmpty ||
        selectedKategoriIuran == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    try {
      final nominal = double.tryParse(nominalController.text. trim());
      if (nominal == null || nominal <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Nominal harus berupa angka valid")),
        );
        return;
      }

      final newKategori = KategoriIuranModel(
        namaKategori: namaKategoriController.text.trim(),
        kategoriIuran: selectedKategoriIuran!,
        nominal: nominal,
      );

      // ✅ Insert ke tabel kategori_iuran saja (tidak ke keluarga)
      await ref.read(kategoriIuranNotifierProvider.notifier).addKategori(newKategori);

      if (! mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Kategori berhasil ditambahkan! "),
          backgroundColor: Colors.green,
        ),
      );
      
      context.pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Gagal menyimpan:  $e"),
          backgroundColor: Colors. red,
        ),
      );
    }
  }

  @override
  void dispose() {
    namaKategoriController.dispose();
    nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: const Text("Tambah Kategori Iuran"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets. all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Nama Kategori",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: namaKategoriController,
              decoration:  InputDecoration(
                hintText: "Contoh: Iuran Kebersihan",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Kategori Iuran",
              style: TextStyle(fontWeight:  FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value:  selectedKategoriIuran,
              items: kategoriIuranOptions. map((kat) {
                return DropdownMenuItem(
                  value:  kat,
                  child:  Text(kat),
                );
              }).toList(),
              onChanged: (value) => setState(() => selectedKategoriIuran = value),
              decoration: InputDecoration(
                hintText: "Pilih Kategori",
                border: OutlineInputBorder(borderRadius: BorderRadius. circular(10)),
                contentPadding: const EdgeInsets. symmetric(horizontal: 12, vertical: 14),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Nominal Default",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: nominalController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration:  InputDecoration(
                hintText: "Contoh: 50000",
                prefixText: "Rp ",
                border: OutlineInputBorder(borderRadius: BorderRadius. circular(10)),
                contentPadding: const EdgeInsets. symmetric(horizontal: 12, vertical: 14),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 48,
              child:  ElevatedButton(
                onPressed: simpanKategori,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7A3FFF),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child:  const Text(
                  "Simpan",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height:  12),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                onPressed: resetForm,
                style:  OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
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