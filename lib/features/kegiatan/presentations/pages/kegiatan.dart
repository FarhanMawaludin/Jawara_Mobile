import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/kegiatan_statistics_provider.dart';
import 'widgets/statistics_card.dart';
import 'widgets/menu_grid.dart';

class KegiatanPage extends ConsumerWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(kegiatanStatisticsProvider);
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  const StatisticsCard(),
                  const SizedBox(height: 24),
                  const MenuGrid(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}