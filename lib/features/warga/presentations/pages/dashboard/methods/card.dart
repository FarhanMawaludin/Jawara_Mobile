import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';

class CardWarga extends ConsumerWidget {
  const CardWarga({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalKeluarga = ref.watch(totalKeluargaProvider);
    final totalWarga = ref.watch(totalWargaProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        final bool oneColumn = width < 380;
        final bool twoColumn = width >= 380;

        return Container(
          padding: EdgeInsets.all(width < 360 ? 12 : 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              if (oneColumn) ...[
                _infoBox(
                  width,
                  icon: HeroiconsOutline.home,
                  title: "Total Keluarga",
                  value: totalKeluarga.when(
                    data: (v) => v.toString(),
                    loading: () => "...",
                    error: (e, _) => "0",
                  ),
                  suffix: "Keluarga",
                ),
                const SizedBox(height: 10),
                _infoBox(
                  width,
                  icon: HeroiconsOutline.userGroup,
                  title: "Total Warga",
                  value: totalWarga.when(
                    data: (v) => v.toString(),
                    loading: () => "...",
                    error: (e, _) => "0",
                  ),
                  suffix: "Warga",
                ),
              ] else if (twoColumn) ...[
                Row(
                  children: [
                    Expanded(
                      child: _infoBox(
                        width,
                        icon: HeroiconsOutline.home,
                        title: "Total Keluarga",
                        value: totalKeluarga.when(
                          data: (v) => v.toString(),
                          loading: () => "...",
                          error: (e, _) => "0",
                        ),
                        suffix: "Keluarga",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _infoBox(
                        width,
                        icon: HeroiconsOutline.userGroup,
                        title: "Total Warga",
                        value: totalWarga.when(
                          data: (v) => v.toString(),
                          loading: () => "...",
                          error: (e, _) => "0",
                        ),
                        suffix: "Warga",
                      ),
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: () => context.push('/warga/statistik'),
                  icon: const Icon(HeroiconsMini.chartBar, color: Colors.white),
                  label: Text(
                    "Statistik",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width < 360 ? 13 : 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    padding: EdgeInsets.symmetric(
                      vertical: width < 360 ? 10 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _infoBox(
    double width, {
    required IconData icon,
    required String title,
    required String value,
    required String suffix,
  }) {
    final isSmall = width < 360;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 10 : 12,
        vertical: isSmall ? 12 : 14,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isSmall ? 14 : 16, color: Colors.grey[800]),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: isSmall ? 13 : 14,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isSmall ? 17 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[900],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                suffix,
                style: TextStyle(
                  fontSize: isSmall ? 11 : 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
