import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';

import '../providers/register_providers.dart';

class RegisterStep1Account extends ConsumerWidget {
  RegisterStep1Account({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  // === MENGAMBIL PESAN ERROR VALIDATOR ===
  List<String> _validateInputs() {
    List<String> errors = [];

    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();

    if (email.isEmpty) {
      errors.add("Email wajib diisi");
    } else if (!_isValidEmail(email)) {
      errors.add("Format email tidak valid");
    }

    if (pass.isEmpty) {
      errors.add("Password wajib diisi");
    } else if (pass.length < 6) {
      errors.add("Password minimal 6 karakter");
    }

    if (confirm.isEmpty) {
      errors.add("Konfirmasi password wajib diisi");
    } else if (confirm != pass) {
      errors.add("Password tidak cocok");
    }

    return errors;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                // === PROGRESS BAR ===
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
                        color: Colors.grey[300],
                        radius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Divider(
                        thickness: 6,
                        color: Colors.grey[300],
                        radius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // === TITLE ===
                Text(
                  'Akun',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.deepPurpleAccent[400],
                  ),
                ),
                Text(
                  'Silahkan buat akun dengan email dan password Anda',
                  style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                ),

                const SizedBox(height: 20),

                // === INPUT FIELD ===
                InputField(
                  label: 'Email',
                  hintText: 'Masukkan Email',
                  controller: _emailController,
                  validator: (_) => null, // kita handle sendiri
                ),

                InputField(
                  label: 'Password',
                  hintText: 'Masukkan Password',
                  isPassword: true,
                  controller: _passwordController,
                  validator: (_) => null,
                ),

                InputField(
                  label: 'Konfirmasi Password',
                  hintText: 'Masukkan Ulang Password',
                  isPassword: true,
                  controller: _confirmController,
                  validator: (_) => null,
                ),

                const SizedBox(height: 20),

                // === BUTTON ===
                TextButton(
                  onPressed: () async {
                    final errors = _validateInputs();

                    // jika ada error → tampil alert
                    if (errors.isNotEmpty) {
                      showBottomAlert(
                        context: context,
                        title: "Validasi Gagal",
                        message: errors.join("\n"),
                        yesText: "Mengerti",
                        onlyYes: true,
                        icon: SizedBox(
                            height:
                                MediaQuery.of(context).size.height *
                                0.22, // 22% tinggi layar
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
                      final usecase = ref.read(registerAccountProvider);

                      final userApp = await usecase.execute(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      // === CEK EMAIL SUDAH TERDAFTAR ===
                      if (userApp == null || userApp.id == null) {
                        showBottomAlert(
                          context: context,
                          title: "Email Sudah Terdaftar",
                          message:
                              "Gunakan email lain atau login jika sudah memiliki akun.",
                          yesText: "Mengerti",
                          onlyYes: true,
                          icon: SizedBox(
                            height:
                                MediaQuery.of(context).size.height *
                                0.22, // 22% tinggi layar
                            child: Lottie.asset(
                              'assets/lottie/Failed.json',
                              fit: BoxFit.contain,
                            ),
                          ),
                          onYes: () => Navigator.pop(context),
                        );
                        return;
                      }

                      // === SIMPAN STATE ===
                      ref
                          .read(registerStateProvider.notifier)
                          .updateAccount(
                            _emailController.text.trim(),
                            _passwordController.text.trim(),
                            userApp.id!,
                          );

                      // === LANJUT STEP 2 ===
                      context.push('/register/step2');
                    } catch (_) {
                      showBottomAlert(
                        context: context,
                        title: "Terjadi Kesalahan",
                        message:
                            "Terjadi kesalahan saat membuat akun. Silakan coba lagi nanti.",
                        yesText: "Tutup",
                        onlyYes: true,
                        onYes: () => Navigator.pop(context),
                      );
                    }
                  },

                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.deepPurpleAccent[400],
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    ),
                    minimumSize: MaterialStateProperty.all(
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
