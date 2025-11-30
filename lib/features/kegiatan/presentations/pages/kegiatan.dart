import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'widgets/statistics_card.dart';
import 'widgets/menu_grid.dart';
import '../providers/kegiatan_statistics_provider.dart';

class KegiatanPage extends ConsumerWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        // Pull-to-refresh untuk update statistik
        onRefresh: () async {
          ref.invalidate(kegiatanStatisticsProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              top: 60,
              left: 16.0,
              right: 16.0,
              bottom: 16.0,
            ),
            child: Column(
              children: [
                // Statistics Card (sekarang auto-fetch dari Supabase)
                const StatisticsCard(),
                const SizedBox(height: 24),

                // Menu Grid
                const MenuGrid(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}