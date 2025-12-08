import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class JudulDetail extends StatelessWidget {
  final String namaKeluarga;
  final bool pindah;
  const JudulDetail({super.key, required this.namaKeluarga, required this.pindah});

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
              const SizedBox(width: 8),
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
        ],
      ),
    );
  }
}
