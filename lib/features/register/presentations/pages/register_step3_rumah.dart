import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:lottie/lottie.dart';

import '../providers/register_providers.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';

class RegisterStep3Rumah extends ConsumerStatefulWidget {
  const RegisterStep3Rumah({super.key});

  @override
  ConsumerState<RegisterStep3Rumah> createState() => _RegisterStep3RumahState();
}

class _RegisterStep3RumahState extends ConsumerState<RegisterStep3Rumah> {
  final _blokController = TextEditingController();
  final _nomorRumahController = TextEditingController();
  final _alamatLengkapController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Load cache step 3
    final cache = ref.read(registerStep3CacheProvider);

    _blokController.text = cache.blok;
    _nomorRumahController.text = cache.nomorRumah;
    _alamatLengkapController.text = cache.alamatLengkap;
  }

  List<String> _validateInputs() {
    final errors = <String>[];

    if (_blokController.text.trim().isEmpty) {
      errors.add("Blok wajib diisi");
    }
    if (_nomorRumahController.text.trim().isEmpty) {
      errors.add("Nomor rumah wajib diisi");
    }
    if (_alamatLengkapController.text.trim().isEmpty) {
      errors.add("Alamat lengkap wajib diisi");
    }

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
            icon: Icon(HeroiconsMini.arrowLeft, color: Colors.grey[900]),
            onPressed: () => context.pop(),
          ),
          titleSpacing: 0,
          title: Text(
            'Register',
            style: TextStyle(
              color: Colors.grey[900],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ------ PROGRESS BAR ------
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
                        color: Colors.deepPurpleAccent[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Text(
                "Data Rumah",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.deepPurpleAccent[400],
                ),
              ),
              Text(
                "Masukkan informasi rumah Anda",
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),

              const SizedBox(height: 16),

              InputField(
                label: "Blok Rumah",
                hintText: "Contoh: A, B, C",
                controller: _blokController,
                validator: (_) => null,
                onChanged: (v) => ref
                    .read(registerStep3CacheProvider.notifier)
                    .updateCache(blok: v),
              ),

              InputField(
                label: "Nomor Rumah",
                hintText: "Contoh: 12, 21A",
                controller: _nomorRumahController,
                validator: (_) => null,
                onChanged: (v) => ref
                    .read(registerStep3CacheProvider.notifier)
                    .updateCache(nomorRumah: v),
              ),

              InputField(
                label: "Alamat Lengkap",
                hintText: "Masukkan alamat lengkap",
                controller: _alamatLengkapController,
                validator: (_) => null,
                onChanged: (v) => ref
                    .read(registerStep3CacheProvider.notifier)
                    .updateCache(alamatLengkap: v),
              ),

              const SizedBox(height: 20),

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
                        child: Lottie.asset("assets/lottie/Failed.json"),
                      ),
                      onYes: () => Navigator.pop(context),
                    );
                    return;
                  }

                  try {
                    /// -------- SUBMIT ALL DATA (SESUAI FLOW BARU) --------
                    await ref
                        .read(registerStateProvider.notifier)
                        .submitAll(ref);

                    ref.invalidate(registerStep1CacheProvider);
                    ref.invalidate(registerStep2CacheProvider);
                    ref.invalidate(registerStep3CacheProvider);

                    /// clear cache setelah berhasil
                    ref.read(registerStep3CacheProvider.notifier).clearCache();

                    showBottomAlert(
                      context: context,
                      title: "Berhasil!",
                      message: "Akun dan data rumah berhasil dibuat.",
                      yesText: "Lanjut Login",
                      onlyYes: true,
                      icon: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Lottie.asset("assets/lottie/Done.json"),
                      ),
                      onYes: () {
                        Navigator.pop(context);
                        context.go('/login');
                      },
                    );
                  } catch (e) {
                    showBottomAlert(
                      context: context,
                      title: "Gagal menyimpan",
                      message: e.toString(),
                      yesText: "Tutup",
                      onlyYes: true,
                      onYes: () => Navigator.pop(context),
                    );
                  }
                },

                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Colors.deepPurpleAccent[400],
                  ),
                  minimumSize: WidgetStateProperty.all(
                    const Size(double.infinity, 50),
                  ),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                child: const Text(
                  "Selesaikan",
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
    );
  }
}
