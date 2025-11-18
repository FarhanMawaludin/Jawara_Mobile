// lib/presentation/pages/register_step3_rumah.dart

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

  /// ===========================================================
  /// VALIDATOR MANUAL
  /// ===========================================================
  List<String> _validateInputs() {
    List<String> errors = [];

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
    final state = ref.watch(registerStateProvider);

    /// Force redirect jika step 2 belum selesai
    if (state.keluargaId == null) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.go('/register/step2'),
      );
      return const SizedBox();
    }

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ==============================================
              /// PROGRESS STEPS (1,2 aktif — 3 aktif)
              /// ==============================================
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 6,
                      color: Colors.deepPurpleAccent[400],
                      radius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Divider(
                      thickness: 6,
                      color: Colors.deepPurpleAccent[400],
                      radius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Divider(
                      thickness: 6,
                      color: Colors.deepPurpleAccent[400],
                      radius: BorderRadius.all(Radius.circular(10)),
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
              const SizedBox(height: 4),
              Text(
                "Masukkan informasi rumah Anda",
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),

              const SizedBox(height: 16),

              /// ===========================================
              /// INPUT FIELDS (SAMA STYLE DENGAN STEP 1 & 2)
              /// ===========================================
              InputField(
                label: "Blok Rumah",
                hintText: "Contoh: A, B, C",
                controller: _blokController,
                validator: (_) => null,
              ),

              InputField(
                label: "Nomor Rumah",
                hintText: "Contoh: 12, 21A",
                controller: _nomorRumahController,
                validator: (_) => null,
              ),

              InputField(
                label: "Alamat Lengkap",
                hintText: "Masukkan alamat lengkap",
                controller: _alamatLengkapController,
                validator: (_) => null,
              ),

              const SizedBox(height: 20),

              /// ===========================================
              /// FINAL BUTTON
              /// ===========================================
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
                          fit: BoxFit.contain,
                        ),
                      ),
                      onYes: () => Navigator.pop(context),
                    );
                    return;
                  }

                  try {
                    final usecase = ref.read(createRumahProvider);

                    await usecase.execute(
                      state.keluargaId!,
                      _blokController.text,
                      _nomorRumahController.text,
                      _alamatLengkapController.text,
                    );

                    /// update global state
                    ref
                        .read(registerStateProvider.notifier)
                        .updateRumah(
                          _blokController.text,
                          _nomorRumahController.text,
                          _alamatLengkapController.text,
                        );

                    /// ============================
                    /// SHOW SUCCESS ALERT DULU
                    /// ============================
                    showBottomAlert(
                      context: context,
                      title: "Berhasil!",
                      message: "Anda berhasil melakukan pendaftaran.",
                      yesText: "Lanjut Login",
                      onlyYes: true,
                      icon: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Lottie.asset(
                          'assets/lottie/Done.json',
                          fit: BoxFit.contain,
                        ),
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
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  ),
                  minimumSize: WidgetStateProperty.all(
                    const Size(double.infinity, 50),
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
