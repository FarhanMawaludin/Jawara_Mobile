// lib/presentation/pages/register_step2_warga.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';

import '../providers/register_providers.dart';

class RegisterStep2Warga extends ConsumerStatefulWidget {
  const RegisterStep2Warga({super.key});

  @override
  ConsumerState<RegisterStep2Warga> createState() => _RegisterStep2WargaState();
}

class _RegisterStep2WargaState extends ConsumerState<RegisterStep2Warga> {
  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _tanggalController = TextEditingController();

  String? _selectedJenisKelamin;
  DateTime? _selectedTanggalLahir;

  @override
  void initState() {
    super.initState();

    // ==== LOAD CACHE ====
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cache = ref.read(registerStep2CacheProvider);

      _namaController.text = cache.nama;
      _nikController.text = cache.nik;
      _selectedJenisKelamin = cache.jenisKelamin;

      if (cache.tanggalLahir != null) {
        _selectedTanggalLahir = cache.tanggalLahir;
        _tanggalController.text =
            cache.tanggalLahir!.toIso8601String().substring(0, 10);
      }
    });
  }

  List<String> _validateInputs() {
    List<String> errors = [];

    final nama = _namaController.text.trim();
    final nik = _nikController.text.trim();
    final tgl = _tanggalController.text.trim();

    if (nama.isEmpty) errors.add("Nama wajib diisi");

    if (nik.isNotEmpty) {
      if (nik.length != 16) errors.add("NIK harus 16 digit");
      if (!RegExp(r'^[0-9]+$').hasMatch(nik)) {
        errors.add("NIK hanya boleh angka");
      }
    }

    if (_selectedJenisKelamin == null) {
      errors.add("Jenis kelamin wajib dipilih");
    }

    if (tgl.isEmpty) errors.add("Tanggal lahir wajib diisi");

    return errors;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(HeroiconsMini.arrowLeft, color: Colors.grey[950]),
            onPressed: () => context.pop(),
          ),
          titleSpacing: 0,
          title: Text(
            'Register',
            style: TextStyle(
              color: Colors.grey[950],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// === PROGRESS BAR ===
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  'Data Warga',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent[400],
                  ),
                ),
                Text(
                  'Silahkan isi data diri Anda dengan benar',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),

                const SizedBox(height: 10),

                /// NAMA
                InputField(
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan Nama',
                  controller: _namaController,
                  validator: (_) => null,
                  onChanged: (v) {
                    ref
                        .read(registerStep2CacheProvider.notifier)
                        .updateCache(nama: v);
                  },
                ),

                /// NIK
                InputField(
                  label: 'NIK (opsional)',
                  hintText: 'Masukkan NIK',
                  controller: _nikController,
                  validator: (_) => null,
                  onChanged: (v) {
                    ref
                        .read(registerStep2CacheProvider.notifier)
                        .updateCache(nik: v);
                  },
                ),

                /// JENIS KELAMIN
                InputField(
                  label: 'Jenis Kelamin',
                  hintText: 'Pilih jenis kelamin',
                  options: const ['Laki-laki', 'Perempuan'],
                  validator: (_) => null,
                  onChanged: (value) {
                    final jk = value == 'Laki-laki' ? 'L' : 'P';
                    _selectedJenisKelamin = jk;

                    ref
                        .read(registerStep2CacheProvider.notifier)
                        .updateCache(jenisKelamin: jk);
                  },
                ),

                /// DATE PICKER
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );

                    if (picked != null) {
                      setState(() {
                        _selectedTanggalLahir = picked;
                        _tanggalController.text =
                            picked.toIso8601String().substring(0, 10);
                      });

                      ref
                          .read(registerStep2CacheProvider.notifier)
                          .updateCache(tanggalLahir: picked);
                    }
                  },
                  child: AbsorbPointer(
                    child: InputField(
                      label: 'Tanggal Lahir',
                      hintText: 'Pilih tanggal lahir',
                      controller: _tanggalController,
                      validator: (_) => null,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// NEXT BUTTON
                TextButton(
                  onPressed: () async {
                    final errors = _validateInputs();

                    if (errors.isNotEmpty) {
                      showBottomAlert(
                        context: context,
                        title: "Form tidak valid",
                        message: errors.join("\n"),
                        yesText: "Mengerti",
                        onlyYes: true,
                        icon: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: Lottie.asset(
                            'assets/lottie/Failed.json',
                          ),
                        ),
                        onYes: () => Navigator.pop(context),
                      );
                      return;
                    }

                    // Simpan cache saja (TIDAK INSERT DB)
                    ref.read(registerStep2CacheProvider.notifier).updateCache(
                          nama: _namaController.text,
                          nik: _nikController.text.isEmpty
                              ? ''
                              : _nikController.text,
                          jenisKelamin: _selectedJenisKelamin,
                          tanggalLahir: _selectedTanggalLahir,
                        );

                    context.push('/register/step3');
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Colors.deepPurpleAccent[400],
                    ),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all(
                      const Size(double.infinity, 50),
                    ),
                  ),
                  child: const Text(
                    "Lanjutkan",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
