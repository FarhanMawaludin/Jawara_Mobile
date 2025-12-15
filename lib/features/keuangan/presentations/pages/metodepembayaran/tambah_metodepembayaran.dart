import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as img_picker;
import '../../../data/models/metodepembayaran_model.dart';
import '../../providers/metodepembayaran/metodepembayaran_providers.dart';

class TambahMetodePembayaranPage extends ConsumerStatefulWidget {
  const TambahMetodePembayaranPage({super.key});

  @override
  ConsumerState<TambahMetodePembayaranPage> createState() =>
      _TambahMetodePembayaranPageState();
}

class _TambahMetodePembayaranPageState
    extends ConsumerState<TambahMetodePembayaranPage> {
  final _formKey = GlobalKey<FormState>();

  final namaController = TextEditingController();
  final nomorController = TextEditingController();
  final pemilikController = TextEditingController();
  final catatanController = TextEditingController();

  String? selectedTipe;
  File? barcodeImage;

  final List<String> tipeList = [
  "Bank",
  "E-Wallet",
  "Qris",
  "Lainnya",
  "Transfer Bank",
];

  Future<void> pickImage() async {
    final picker = img_picker.ImagePicker();
    final picked = await picker.pickImage(
      source: img_picker.ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      setState(() => barcodeImage = File(picked.path));
    }
  }

  void resetForm() {
    setState(() {
      namaController.clear();
      nomorController.clear();
      pemilikController.clear();
      catatanController.clear();
      selectedTipe = null;
      barcodeImage = null;
    });
  }

  Future<void> submit() async {
  if (!_formKey.currentState!.validate()) return;

  if (selectedTipe == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tipe pembayaran belum dipilih")),
    );
    return;
  }

  final datasource = ref.read(metodePembayaranDatasourceProvider);
  
  // 1. Upload barcode jika ada
  String? barcodeUrl;
  if (barcodeImage != null) {
    barcodeUrl = await datasource.uploadBarcode(barcodeImage);
  }

  // 2. Buat model (fotoBarcode nullable)
  final metode = MetodePembayaranModel(
    namaMetode: namaController.text.trim(),
    tipe: selectedTipe!,
    nomorRekening: int.tryParse(nomorController.text.trim()) ?? 0,
    namaPemilik: pemilikController.text.trim(),
    fotoBarcode: barcodeUrl,       // <= NULL atau URL Supabase
    thumbnail: barcodeUrl ?? '',  // <= NULL atau URL Supabase
    catatan: catatanController.text.trim(),
  );


  // 3. Insert
  final notifier =
      ref.read(metodePembayaranNotifierProvider.notifier);

  await notifier.addMetode(metode);

  if (mounted) Navigator.pop(context);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Metode Pembayaran"),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // NAMA METODE
              const Text("Nama Metode"),
              const SizedBox(height: 6),
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Contoh: BCA, Dana, Mandiri",
                ),
                validator: (v) =>
                    v!.isEmpty ? "Nama metode wajib diisi" : null,
              ),
              const SizedBox(height: 16),

              // TIPE METODE
              const Text("Tipe Pembayaran"),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedTipe,
                items: tipeList
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (v) => setState(() => selectedTipe = v),
                validator: (v) =>
                    v == null ? "Tipe pembayaran wajib dipilih" : null,
              ),
              const SizedBox(height: 16),

              // NOMOR REKENING
              const Text("Nomor Rekening / Akun"),
              const SizedBox(height: 6),
              TextFormField(
                controller: nomorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Masukkan nomor rekening / akun",
                ),
              ),
              const SizedBox(height: 16),

              // NAMA PEMILIK
              const Text("Nama Pemilik"),
              const SizedBox(height: 6),
              TextFormField(
                controller: pemilikController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Nama pemilik rekening",
                ),
              ),
              const SizedBox(height: 16),

              // UPLOAD BARCODE
              const Text("Upload Barcode / QR"),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple.withOpacity(0.05),
                  ),
                  child: barcodeImage == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file,
                                color: Colors.deepPurple),
                            SizedBox(height: 8),
                            Text(
                              "Upload Barcode / QR (.png/.jpg)",
                              style:
                                  TextStyle(color: Colors.deepPurple),
                            )
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            barcodeImage!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),

              // CATATAN
              const Text("Catatan"),
              const SizedBox(height: 6),
              TextFormField(
                controller: catatanController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: "Catatan tambahan (opsional)",
                ),
              ),
              const SizedBox(height: 24),

              // SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: submit,
                  child: const Text(
                    "Simpan Metode",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: resetForm,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Reset"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
