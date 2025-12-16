import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart' as img_picker;
import '../../../domain/entities/pemasukanlainnya.dart';
import '../../providers/pemasukanlainnya/pemasukanlainnya_providers.dart';
import '../../providers/mutasi/mutasi_providers.dart'; // TAMBAHKAN
import 'package:jawaramobile/core/utils/currency_formatter.dart';


class TambahPemasukanPage extends ConsumerStatefulWidget {
  const TambahPemasukanPage({super.key});

  @override
  ConsumerState<TambahPemasukanPage> createState() => _TambahPemasukanPageState();
}

class _TambahPemasukanPageState extends ConsumerState<TambahPemasukanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  String? _kategori;
  File? _buktiPemasukan;

  final List<String> _kategoriList = [
    'Donasi',
    'Dana Bantuan Pemerintah',
    'Sumbangan',
    'Swadaya',
    'Hasil Uang Kampung',
    'Pendapatan Lainnya',
  ];

  Future<void> _pickTanggal() async {
    DateTime? picked = await showDatePicker(
      context:  context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _tanggalController. text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = img_picker. ImagePicker();
    final pickedFile =
        await picker. pickImage(source: img_picker.ImageSource.gallery, imageQuality: 80);

    if (pickedFile != null) {
      setState(() {
        _buktiPemasukan = File(pickedFile.path);
      });
    }
  }

  void _resetForm() {
    setState(() {
      _namaController.clear();
      _tanggalController.clear();
      _nominalController.clear();
      _kategori = null;
      _buktiPemasukan = null;
    });
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_kategori == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kategori belum dipilih')),
        );
        return;
      }

      try {
        // Ambil nilai numerik dari nominal (hilangkan format)
        final nominalText = _nominalController.text. replaceAll(RegExp(r'[^0-9]'), '');
        final nominal = double.parse(nominalText);

        final pemasukan = PemasukanLainnya(
          id: 0,
          createdAt: DateTime.now(),
          namaPemasukan: _namaController.text.trim(),
          kategoriPemasukan: _kategori!,
          tanggalPemasukan: DateTime.now(),
          jumlah: nominal,
          buktiPemasukan: _buktiPemasukan?.path ??  '',
        );

        // Simpan data
        final notifier = ref.read(pemasukanNotifierProvider.notifier);
        await notifier. createData(pemasukan);

        // INVALIDATE PROVIDERS untuk refresh otomatis
        ref.invalidate(allTransactionsProvider);
        ref.invalidate(totalSaldoProvider);
        ref.invalidate(statistikProvider);
        ref.invalidate(fetchPemasukanProvider);

        if (mounted) {
          ScaffoldMessenger. of(context).showSnackBar(
            const SnackBar(content: Text('Pemasukan berhasil disimpan!')),
          );
          // Return true untuk trigger refresh di halaman sebelumnya
          Navigator.pop(context, true);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Tambah Pemasukan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nama Pemasukan
              const Text('Nama Pemasukan'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _namaController,
                decoration:  InputDecoration(
                  hintText: 'Nama Pemasukan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator:  (value) =>
                    value!.isEmpty ? 'Nama pemasukan wajib diisi' : null,
              ),
              const SizedBox(height:  16),

              // Tanggal
              const Text('Tanggal Pemasukan'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _tanggalController,
                readOnly: true,
                onTap: _pickTanggal,
                decoration: InputDecoration(
                  hintText: 'Pilih Tanggal',
                  suffixIcon:  const Icon(Icons.calendar_today_outlined),
                  border:  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) =>
                    value!. isEmpty ? 'Tanggal wajib dipilih' :  null,
              ),
              const SizedBox(height: 16),

              // Kategori
              const Text('Kategori Pemasukan'),
              const SizedBox(height: 5),
              DropdownButtonFormField<String>(
                value: _kategori,
                items: _kategoriList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                decoration: InputDecoration(
                  hintText: 'Pilih Kategori',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius. circular(12),
                  ),
                ),
                onChanged:  (value) {
                  setState(() {
                    _kategori = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Kategori wajib dipilih' : null,
              ),
              const SizedBox(height: 16),

              // Nominal dengan Format Currency
              const Text('Nominal Pemasukan'),
              const SizedBox(height: 5),
              TextFormField(
                controller: _nominalController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(), // Format otomatis
                ],
                decoration: InputDecoration(
                  hintText: 'Masukkan nominal',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nominal wajib diisi';
                  }
                  final nominal = int.tryParse(value.replaceAll(RegExp(r'[^0-9]'), ''));
                  if (nominal == null || nominal <= 0) {
                    return 'Nominal tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Bukti Upload
              const Text('Bukti'),
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
                  child: _buktiPemasukan == null
                      ? Column(
                          mainAxisAlignment:  MainAxisAlignment.center,
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
                            _buktiPemasukan!,
                            fit:  BoxFit.cover,
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
                  style: ElevatedButton. styleFrom(
                    backgroundColor:  Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitForm,
                  child: const Text(
                    'Submit',
                    style:  TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Tombol Reset
              SizedBox(
                width:  double.infinity,
                height: 45,
                child: OutlinedButton(
                  onPressed: _resetForm,
                  style: OutlinedButton. styleFrom(
                    shape:  RoundedRectangleBorder(
                      borderRadius:  BorderRadius.circular(12),
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