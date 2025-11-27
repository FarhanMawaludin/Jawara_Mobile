import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';

import '../providers/register_providers.dart';

class RegisterStep1Account extends ConsumerStatefulWidget {
  const RegisterStep1Account({super.key});

  @override
  ConsumerState<RegisterStep1Account> createState() =>
      _RegisterStep1AccountState();
}

class _RegisterStep1AccountState extends ConsumerState<RegisterStep1Account> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // === Load Cache Data ===
    final cache = ref.read(registerStep1CacheProvider);

    _emailController.text = cache.email;
    _passwordController.text = cache.password;
    _confirmController.text = cache.confirmPassword;

    // === Listen perubahan dan simpan ke cache ===
    _emailController.addListener(() {
      ref
          .read(registerStep1CacheProvider.notifier)
          .updateCache(email: _emailController.text);
    });

    _passwordController.addListener(() {
      ref
          .read(registerStep1CacheProvider.notifier)
          .updateCache(password: _passwordController.text);
    });

    _confirmController.addListener(() {
      ref
          .read(registerStep1CacheProvider.notifier)
          .updateCache(confirmPassword: _confirmController.text);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // === Email regex validator ===
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  // === Validasi manual ===
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(HeroiconsMini.arrowLeft, color: Colors.grey[950]),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Register',
          style: TextStyle(
            color: Colors.grey[950],
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== PROGRESS BAR =====
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
                          color: Colors.grey[300],
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

                // ===== TITLE =====
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

                // ===== INPUT FIELD =====
                InputField(
                  label: 'Email',
                  hintText: 'Masukkan Email',
                  controller: _emailController,
                  validator: (_) => null,
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

                // ===== BUTTON LANJUT =====
                TextButton(
                  onPressed: () async {
                    final errors = _validateInputs();

                    if (errors.isNotEmpty) {
                      showBottomAlert(
                        context: context,
                        title: "Validasi Gagal",
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

                    // === Simpan ke cache step 1 ===
                    ref.read(registerStep1CacheProvider.notifier).updateCache(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          confirmPassword: _confirmController.text.trim(),
                        );

                    // === Lanjut ke langkah berikutnya ===
                    context.push('/register/step2');
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
                      const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
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
