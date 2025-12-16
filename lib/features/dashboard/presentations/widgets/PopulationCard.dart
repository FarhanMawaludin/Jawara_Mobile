// lib/features/dashboard/presentations/widgets/PopulationCard.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../warga/presentations/providers/statistik/statistik_warga.dart';

class PopulationCard extends ConsumerWidget {
  const PopulationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistikState = ref.watch(statistikWargaControllerProvider);
    
    final Color fillColor = const Color(0xFFF5E5FF);
    final Color textColor = const Color(0xFF8F00E2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textColor.withAlpha((0.3 * 255).round())),
      ),
      child: Row(
        children: [
          Icon(Icons.people, color: textColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Penduduk',
                  style: TextStyle(color: textColor, fontSize: 16),
                ),
                const SizedBox(height: 4),
                statistikState.isLoading
                    ? SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(textColor),
                        ),
                      )
                    : statistikState.error != null
                        ? Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            '${statistikState.data?.totalWarga ?? 0}',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}