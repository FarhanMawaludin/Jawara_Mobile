// lib/features/dashboard/presentations/widgets/ActivitiesSection.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../../kegiatan/presentations/providers/kegiatan_statistics_provider.dart';

class ActivitiesSection extends ConsumerWidget {
  const ActivitiesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statisticsAsync = ref.watch(kegiatanStatisticsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Kegiatan',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              statisticsAsync.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () => ref.invalidate(kegiatanStatisticsProvider),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
            ],
          ),
          const SizedBox(height: 16),
          
          statisticsAsync.when(
            data: (statistics) => Column(
              children: [
                // Total Activities Count
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: '${statistics.totalKegiatan}',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          TextSpan(
                            text: ' Kegiatan',
                            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Activity Status Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildActivityCard(
                        HeroiconsSolid.checkCircle,
                        Colors.blue,
                        'Selesai',
                        '${statistics.selesai}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActivityCard(
                        HeroiconsSolid.arrowPath,
                        Colors.amber,
                        'Hari Ini',
                        '${statistics.hariIni}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildActivityCard(
                        HeroiconsSolid.calendar,
                        Colors.green,
                        'Akan Datang',
                        '${statistics.akanDatang}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(kegiatanStatisticsProvider),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(
    IconData icon,
    Color color,
    String label,
    String count,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withAlpha((0.1 * 255).round()),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withAlpha((0.3 * 255).round())),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(
            count,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}