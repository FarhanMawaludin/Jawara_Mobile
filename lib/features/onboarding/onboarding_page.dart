import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  bool isRegisterSelected = true; // untuk animasi tombol

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // =======================
                  //      RESPONSIVE IMAGE
                  // =======================
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/images/background.jpg',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =======================
                  //      TEXT SECTION
                  // =======================
                  Column(
                    children: [
                      Text(
                        'Jawara Pintar',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurpleAccent[400],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Solusi digital untuk manajemen keuangan \ndan kegiatan warga',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.045,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 35),

                  // =======================
                  //    ANIMATED BUTTONS
                  // =======================
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    height: 60,
                    width: double.infinity,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Stack(
                      children: [
                        // BG bergerak
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                          alignment: isRegisterSelected
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            width: (constraints.maxWidth - 40) / 2,
                            decoration: BoxDecoration(
                              color: Colors.deepPurpleAccent[400],
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),

                        Row(
                          children: [
                            // REGISTER BUTTON
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => isRegisterSelected = true);
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () => context.push('/register/step1'),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "Register",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: isRegisterSelected
                                          ? Colors.white
                                          : Colors.deepPurpleAccent[400],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // LOGIN BUTTON
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() => isRegisterSelected = false);
                                  Future.delayed(
                                    const Duration(milliseconds: 200),
                                    () => context.push('/login'),
                                  );
                                },
                                child: Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: !isRegisterSelected
                                          ? Colors.white
                                          : Colors.deepPurpleAccent[400],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
