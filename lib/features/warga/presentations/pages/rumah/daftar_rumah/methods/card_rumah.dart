// lib/features/warga/presentation/pages/daftar_rumah/methods/card_rumah.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class CardRumah extends StatelessWidget {
  final String namaRumah; // contoh: Griyashanta L.203
  final bool ditempati; // kalau true → ditempati, kalau false → kosong
  final int rumahId; // untuk navigasi detail

  const CardRumah({
    super.key,
    required this.namaRumah,
    required this.ditempati,
    required this.rumahId,
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
                  fontWeight: FontWeight.w400,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              context.push('/warga/daftar-rumah/detail/$rumahId');
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
