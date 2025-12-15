import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../log_activity/log_activity.dart';
import 'package:go_router/go_router.dart';

import '../../../../auth/presentations/providers/login_providers.dart';
import '../../../../../core/component/bottom_alert.dart';

Widget buildStyledButton({
  required BuildContext context,
  required IconData icon,
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      margin: EdgeInsets.zero,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: color),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class SettingsButtonSection extends ConsumerWidget {
  const SettingsButtonSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Color accentColor = const Color(0xFF635BFF);
    final Color dangerColor = Colors.red.shade600;

    return Column(
      children: [
        buildStyledButton(
          context: context,
          icon: Icons.history,
          title: 'Log Aktivitas',
          color: accentColor,
          onTap: () => Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const LogActivityPage())),
        ),
        const SizedBox(height: 12),

        buildStyledButton(
          context: context,
          icon: Icons.swap_horiz,
          title: 'Channel Transfer',
          color: accentColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Channel Transfer akan segera hadir'),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        buildStyledButton(
          context: context,
          icon: Icons.people,
          title: 'Manajemen Pengguna',
          color: accentColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Manajemen Pengguna akan segera hadir'),
              ),
            );
          },
        ),
        const SizedBox(height: 12),

        buildStyledButton(
          context: context,
          icon: Icons.family_restroom,
          title: 'Mutasi Keluarga',
          color: accentColor,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Mutasi Keluarga akan segera hadir'),
              ),
            );
          },
        ),
        const SizedBox(height: 24),

        // ===========================
        // 🔥 LOGOUT (with Bottom Sheet)
        // ===========================
        buildStyledButton(
          context: context,
          icon: Icons.logout,
          title: 'Logout',
          color: dangerColor,
          onTap: () {
            showBottomAlert(
              context: context,
              title: "Konfirmasi Logout",
              message: "Apakah Anda yakin ingin keluar dari aplikasi?",
              yesText: "Logout",
              noText: "Batal",

              onYes: () async {
                Navigator.pop(context);

                await ref.read(authControllerProvider.notifier).signOut();

                context.go('/login');
              },

              onNo: () => Navigator.pop(context),
            );
          },
        ),
      ],
    );
  }
}
