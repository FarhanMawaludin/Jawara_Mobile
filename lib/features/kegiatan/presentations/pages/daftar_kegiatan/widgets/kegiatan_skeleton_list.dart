import 'package:flutter/material.dart';
import '../../widgets/skeleton_kegiatan_card.dart';

class KegiatanSkeletonList extends StatelessWidget {
  const KegiatanSkeletonList({super.key});

  static const int _skeletonCount = 6;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _skeletonCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => const SkeletonKegiatanCard(),
    );
  }
}