import 'package:flutter/material.dart';
import 'methods/account_card.dart';
import 'methods/button_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header container with SharedHeader
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey[300]!, width: 1),
              ),
            ),
            padding: const EdgeInsets.only(top: 8.0),
            child: const SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                child: Text(
                  'Pengaturan',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          // Content area
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Akun', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                const AccountCard(),
                const SizedBox(height: 24),
                Text('Menu Pengaturan', style: theme.textTheme.titleLarge),
                const SizedBox(height: 8),
                const SettingsButtonSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
