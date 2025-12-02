import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/kegiatan_statistics_provider.dart';
import 'status_item.dart';

class StatisticsCard extends ConsumerWidget {
  const StatisticsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch statistik dari provider
    final statisticsAsync = ref.watch(kegiatanStatisticsProvider);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(20),
      child: statisticsAsync.when(
        // Saat loading
        loading: () => const Center(
          child: Padding(
            padding: EdgeInsets.all(40.0),
            child: CircularProgressIndicator(
              color: Color(0xFF6C63FF),
            ),
          ),
        ),
        
        // Saat error
        error: (error, stack) {
          print('ERROR in StatisticsCard: $error');
          print('Stack: $stack');
          
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline, size: 48, color: Colors.red[300]),
                const SizedBox(height: 8),
                Text(
                  'Gagal memuat statistik',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  error.toString(),
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(kegiatanStatisticsProvider);
                  },
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Coba Lagi'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C63FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        
        // Saat data berhasil dimuat
        data: (statistics) => Column(
          children: [
            // Total Kegiatan
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${statistics.totalKegiatan}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    height: 1,
                    color: Color(0xFF6C63FF),
                  ),
                ),
                const SizedBox(width: 8),
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text(
                    'Kegiatan',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // Status Row
            Row(
              children: [
                Expanded(
                  child: StatusItem(
                    icon: Icons.check_circle_outline,
                    iconColor: Colors.green,
                    label: 'Selesai',
                    value: '${statistics.selesai}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatusItem(
                    icon: Icons.today_outlined,
                    iconColor: Colors.blue,
                    label: 'Hari Ini',
                    value: '${statistics.hariIni}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatusItem(
                    icon: Icons.calendar_today_outlined,
                    iconColor: Colors.orange,
                    label: 'Akan Datang',
                    value: '${statistics.akanDatang}',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Refresh button (optional)
            TextButton.icon(
              onPressed: () {
                ref.invalidate(kegiatanStatisticsProvider);
              },
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Refresh'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6C63FF),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}