import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as img_picker;

class TambahPengeluaranPage extends StatefulWidget {
  const TambahPengeluaranPage({super.key});

  @override
  State<TambahPengeluaranPage> createState() => _TambahPengeluaranPageState();
}

class _TambahPengeluaranPageState extends State<TambahPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  String? _kategori;
  File? _buktiFile;

  final List<String> _kategoriList = [
    'Gaji',
    'Bonus',
    'Investasi',
    'Lainnya',
  ];

  Future<void> _pickTanggal() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = img_picker.ImagePicker();
    final pickedFile =
        await picker.pickImage(source: img_picker.ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _buktiFile = File(pickedFile.path);
      });
    }
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _tanggalController.clear();
      _nominalController.clear();
      _kategori = null;
      _buktiFile = null;
    });
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Simulasi submit
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pemasukan berhasil disimpan!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Tambah Pengeluaran'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Pemasukan
              const Text('Nama Pengeluaran'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Nama Pengeluaran',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Nama pengeluaran wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Tanggal
              const Text('Tanggal Pengeluaran'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _pickTanggal,
                decoration: InputDecoration(
                  hintText: 'Pilih Tanggal',
                  suffixIcon: const Icon(Icons.calendar_today_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Tanggal wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              // Kategori
              const Text('Kategori Pengeluaran'),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                initialValue: _kategori,
                items: _kategoriList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(
                  hintText: 'Pilih Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              // Nominal
              const Text('Nominal'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Masukkan nominal',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Nominal wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Bukti Upload
              const Text('Catatan/Bukti Pengeluaran'),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 140,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.deepPurple),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.deepPurple.withOpacity(0.05),
                  ),
                  child: _buktiFile == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file, color: Colors.deepPurple),
                            SizedBox(height: 8),
                            Text(
                              'Upload Bukti Pemasukan (.png/.jpg)',
                              style: TextStyle(color: Colors.deepPurple),
                            ),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            _buktiFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Submit
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
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tombol Reset
              SizedBox(
                width: double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}