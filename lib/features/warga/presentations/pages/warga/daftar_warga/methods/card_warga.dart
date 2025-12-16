import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class CardWarga extends ConsumerWidget {
  final String nama;
  final String keluargaNama;
  final bool isVerified;
  final int wargaId;

  const CardWarga({
    super.key,
    required this.nama,
    required this.keluargaNama,
    required this.isVerified,
    required this.wargaId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        context.push('/warga/aspirasi?wargaId=$wargaId');
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // -----------------------------------------------------
            // NAMA + VERIFIED
            // -----------------------------------------------------
          Row(
            children: [
              Text(
                nama,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 6),
              if (isVerified)
                Icon(
                  HeroiconsOutline.checkBadge,
                  size: 18,
                  color: isVerified ? Colors.green[600] : Colors.grey[600],
                ),
            ],
          ),

          const SizedBox(height: 8),

          // -----------------------------------------------------
          // NAMA KELUARGA
          // -----------------------------------------------------
          Row(
            children: [
              Icon(HeroiconsOutline.user, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                keluargaNama,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // -----------------------------------------------------
          // DETAIL BUTTON
          // -----------------------------------------------------
          TextButton(
            onPressed: () {
              context.push('/warga/daftar-warga/detail/$wargaId');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent[400],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              minimumSize: const Size(double.infinity, 0),
            ),
            child: const Text(
              "Detail",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // -----------------------------------------------------
          // EDIT & DELETE BUTTONS
          // -----------------------------------------------------
          Row(
            children: [
              // EDIT BUTTON
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/warga/daftar-warga/edit/$wargaId');
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.blue[600]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Edit",
                    style: TextStyle(
                      color: Colors.blue[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // DELETE BUTTON
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showBottomAlert(
                      context: context,
                      title: "Hapus Warga?",
                      message:
                          "Aksi ini tidak dapat dibatalkan. Apakah Anda yakin ingin menghapus warga ini?",
                      yesText: "Hapus",
                      noText: "Batal",
                      onYes: () async {
                        Navigator.pop(context); // tutup alert

                        /// PANGGIL USECASE DENGAN PROVIDER YANG BENAR
                        final delete = ref.read(deleteWargaUseCaseProvider);
                        await delete(wargaId);

                        // BUAT LOG ACTIVITY
                        await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
                          title: 'Menghapus warga: $nama',
                        );

                        // Refresh list warga
                        ref.invalidate(wargaListProvider);
                      },
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.red[400]!),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Hapus",
                    style: TextStyle(
                      color: Colors.red[600],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}
