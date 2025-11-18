import 'package:flutter/material.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

class JudulDetail extends StatelessWidget {
  const JudulDetail({super.key});

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
                "Raudhil Firdaus Naufal",
                style: TextStyle(
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                HeroiconsOutline.checkBadge,
                size: 18,
                color: Colors.green[600],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
