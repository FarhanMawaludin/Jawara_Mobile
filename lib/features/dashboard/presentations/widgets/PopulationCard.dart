import 'package:flutter/material.dart';

class PopulationCard extends StatelessWidget {
  const PopulationCard({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the hex color values
    final Color fillColor = Color(0xFFF5E5FF); // F5E5FF - light purple
    final Color textColor = Color(0xFF8F00E2); // 8F00E2 - purple

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(16),
  border: Border.all(color: textColor.withAlpha((0.3 * 255).round())), // subtle border
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: textColor, size: 32),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Total Penduduk',
                style: TextStyle(color: textColor, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                '72',
                style: TextStyle(
                  color: textColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}