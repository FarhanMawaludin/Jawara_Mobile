import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class CardMutasi extends StatelessWidget {
  final String namaKeluarga;
  final bool pindah;
  final int mutasiId;

  const CardMutasi({
    super.key,
    required this.namaKeluarga,
    required this.pindah,
    required this.mutasiId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                namaKeluarga,
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                HeroiconsOutline.checkBadge,
                size: 18,
                color: pindah ? Colors.green[600] : Colors.grey[500],
              ),
              const SizedBox(width: 4),
              Text(
                pindah ? "Pindah Rumah" : "Keluar Perumahan",
                style: TextStyle(
                  color: pindah ? Colors.green[600] : Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.push('/warga/daftar-mutasi/detail/$mutasiId');
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.deepPurpleAccent[400],
              padding: const EdgeInsets.symmetric(vertical: 12),
              overlayColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              minimumSize: const Size(double.infinity, 0),
              side: BorderSide(color: Colors.deepPurpleAccent[400]!, width: 1),
            ),
            child: const Text(
              "Detail",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
