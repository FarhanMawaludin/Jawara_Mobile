import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../../widgets/menuItemWidget.dart';

class Itemmenu extends StatelessWidget {
  const Itemmenu({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;

        // Lebar minimum setiap item grid
        const double minItemWidth = 80;

        // Hitung jumlah kolom berdasarkan lebar layar
        int crossAxisCount = (width / minItemWidth).floor();

        // Batasi agar tidak terlalu banyak
        if (crossAxisCount < 3) crossAxisCount = 3;
        if (crossAxisCount > 5) crossAxisCount = 5;

        return GridView.count(
          crossAxisCount: crossAxisCount,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            MenuItemWidget(
              icon: HeroiconsOutline.userGroup,
              label: "Keluarga",
              onTap: () => context.push('/warga/keluarga'),
            ),

            MenuItemWidget(
              icon: HeroiconsOutline.userPlus,
              label: "Tambah Warga",
              onTap: () => context.push('/warga/tambah-warga'),
            ),

            MenuItemWidget(
              icon: HeroiconsOutline.home,
              label: "Tambah Rumah",
              onTap: () => context.push('/warga/tambah-rumah'),
            ),

            MenuItemWidget(
              icon: HeroiconsOutline.bookOpen,
              label: "Daftar Warga",
              onTap: () => context.push('/warga/daftar-warga'),
            ),

            MenuItemWidget(
              icon: HeroiconsOutline.ellipsisVertical,
              label: "Lainnya",
              onTap: () => context.push('/warga/lainnya'),
            ),
          ],
        );
      },
    );
  }
}
