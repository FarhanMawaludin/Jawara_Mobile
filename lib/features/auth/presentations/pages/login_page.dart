import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:jawaramobile/core/component/bottom_success_alert.dart';
import '../../../../core/component/InputField.dart';
import '../providers/login_providers.dart';
import 'package:lottie/lottie.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin {
  final emailC = TextEditingController();
  final passC = TextEditingController();

  late final ProviderSubscription<AuthState> authSub;
  late AnimationController _lottieController;

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);

    authSub = ref.listenManual<AuthState>(authControllerProvider, (
      previous,
      next,
    ) {
      if (!next.loading && next.user != null && next.error == null) {
        showBottomSuccessAlert(
          context: context,
          title: "Login Berhasil",
          message: "Selamat datang kembali!",
          icon: SizedBox(
            height:
                MediaQuery.of(context).size.height * 0.22,
            child: Lottie.asset(
              'assets/lottie/Done.json',
              fit: BoxFit.contain,
              controller: _lottieController,
              onLoaded: (composition) {
                _lottieController.duration = composition.duration ~/ 10; 
                _lottieController.forward();
              },
            ),
          ),
          duration: const Duration(seconds: 1),
          onComplete: () {
            context.push('/homepage');
          },
        );
      }

      if (next.error != null && next.error != previous?.error) {
        showBottomAlert(
          context: context,
          title: "Login Gagal",
          message: next.error!,
          yesText: "OK",
          onlyYes: true,
          onYes: () => Navigator.pop(context),
        );
      }
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    authSub.close();
    emailC.dispose();
    passC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          leading: InkWell(
            onTap: () => context.push('/'),
            child: Icon(HeroiconsMini.arrowLeft, color: Colors.grey[950]),
          ),
          title: Text(
            "Login",
            key: const Key("loginPageTitle"),
            style: TextStyle(
              color: Colors.grey[950],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth;

            return Center(
              child: Container(
                width: maxWidth > 500 ? 450 : maxWidth * 0.9,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: [
                    /// ==============================
                    /// HEADER
                    /// ==============================
                    Text(
                      'Jawara Pintar',
                      style: TextStyle(
                        fontSize: maxWidth > 500 ? 32 : 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurpleAccent[400],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Solusi digital untuk manajemen keuangan \ndan kegiatan warga',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: maxWidth > 500 ? 16 : 13,
                        color: Colors.grey[700],
                      ),
                    ),

                    const SizedBox(height: 20),

                    /// ==============================
                    /// INPUT EMAIL
                    /// ==============================
                    InputField(
                      key: const Key("emailField"),
                      label: "Email",
                      hintText: "Masukkan email",
                      controller: emailC,
                    ),

                    /// ==============================
                    /// INPUT PASSWORD
                    /// ==============================
                    InputField(
                      key: const Key("passwordField"),
                      label: "Password",
                      hintText: "Masukkan password",
                      isPassword: true,
                      controller: passC,
                    ),

                    const SizedBox(height: 30),

                    /// ==============================
                    /// BUTTON LOGIN
                    /// ==============================
                    authState.loading
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: TextButton(
                              key: const Key("loginButton"),
                              onPressed: () {
                                final email = emailC.text.trim();
                                final password = passC.text.trim();

                                if (email.isEmpty || password.isEmpty) {
                                  showBottomAlert(
                                    context: context,
                                    title: "Login Gagal",
                                    message: "Email atau password salah.",
                                    yesText: "OK",
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

                                ref
                                    .read(authControllerProvider.notifier)
                                    .login(email, password);
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
                              ),
                              child: const Text(
                                "Login",
                                key: Key("loginButtonText"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
