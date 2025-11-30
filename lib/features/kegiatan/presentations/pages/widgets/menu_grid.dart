import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'menu_card.dart';

class MenuGrid extends StatelessWidget {
  const MenuGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.2,
      children: [
        MenuCard(
          icon: HeroiconsOutline.userPlus,
          label: 'Tambah\nKegiatan',
          onTap: () {
            context.push('/kegiatan/tambah-kegiatan');
          },
        ),
        MenuCard(
          icon: HeroiconsOutline.clipboardDocumentList,
          label: 'Daftar\nKegiatan',
          onTap: () {
            context.push('/kegiatan/daftar-kegiatan');
          },
        ),
        MenuCard(
          icon: HeroiconsOutline.userGroup,
          label: 'Tambah\nBroadcast',
          onTap: () {
            context.push('/broadcast/tambah-broadcast');
          },
        ),
        MenuCard(
          icon: HeroiconsOutline.rectangleStack,
          label: 'Daftar\nBroadcast',
          onTap: () {
           context.push('/broadcast/daftar-broadcast');
          },
        ),
      ],
    );
  }
}