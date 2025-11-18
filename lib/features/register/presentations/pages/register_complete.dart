// lib/presentation/pages/register_complete.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RegisterComplete extends StatelessWidget {
  const RegisterComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration Complete')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Registration successful!'),
            ElevatedButton(
              onPressed: () => context.go('/login'),
              child: const Text('Go to Login'),
            ),
          ],
        ),
      ),
    );
  }
}