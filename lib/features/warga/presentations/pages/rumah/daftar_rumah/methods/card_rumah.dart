import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';


class CardRumah extends ConsumerWidget {
  final String namaRumah;
  final bool ditempati;
  final int rumahId;

  const CardRumah({
    super.key,
    required this.namaRumah,
    required this.ditempati,
    required this.rumahId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // -----------------------------------------------------
          // HEADER
          // -----------------------------------------------------
          Row(
            children: [
              Text(
                namaRumah,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // -----------------------------------------------------
          // STATUS
          // -----------------------------------------------------
          Row(
            children: [
              Icon(
                HeroiconsOutline.checkBadge,
                size: 18,
                color: ditempati ? Colors.green[600] : Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                ditempati ? "Ditempati" : "Kosong",
                style: TextStyle(
                  color: ditempati ? Colors.green[600] : Colors.grey[600],
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
              context.push('/warga/daftar-rumah/detail/$rumahId');
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
              // EDIT
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/warga/daftar-rumah/edit/$rumahId');
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

              // DELETE
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    showBottomAlert(
                      context: context,
                      title: "Hapus Rumah?",
                      message:
                          "Aksi ini tidak dapat dibatalkan. Apakah Anda yakin ingin menghapus rumah ini?",
                      yesText: "Hapus",
                      noText: "Batal",
                      onYes: () async {
                        Navigator.pop(context); // tutup alert

                        /// PANGGIL USECASE DENGAN PROVIDER YANG BENAR
                        final delete = ref.read(deleteRumahProvider);
                        await delete(rumahId);

                        // Refresh list rumah
                        ref.invalidate(rumahListProvider);
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
    );
  }
}
