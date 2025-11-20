import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class JudulDetail extends StatelessWidget {
  final String namaKeluarga;
  final String alamat;
  final String status;


  const JudulDetail({
    super.key,
    required this.namaKeluarga,
    required this.alamat,
    required this.status,

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
              const SizedBox(width: 8),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  Icon(
                    HeroiconsOutline.mapPin,
                    size: 16,
                    color: Colors.deepPurpleAccent[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    alamat,
                    style: TextStyle(
                      color: Colors.deepPurpleAccent[400],
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Icon(
                    HeroiconsOutline.checkBadge,
                    size: 18,
                    color: status.toLowerCase() == 'aktif'
                        ? Colors.green[600]
                        : Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    status,
                    style: TextStyle(
                      color: status.toLowerCase() == 'aktif'
                          ? Colors.green[600]
                          : Colors.grey,
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}
