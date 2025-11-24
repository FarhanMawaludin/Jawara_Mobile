import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import '../../widgets/menuItemWidget.dart';

class Lainnya extends StatelessWidget {
  const Lainnya({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Lainnya',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        leading: IconButton(
          icon: const Icon(HeroiconsMini.arrowLeft),
          onPressed: () => context.pop(),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
        titleSpacing: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Warga & Rumah", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 30,
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
                      icon: HeroiconsOutline.bookOpen,
                      label: "Daftar Warga",
                      onTap: () => context.push('/warga/daftar-warga'),
                    ),

                    MenuItemWidget(
                      icon: HeroiconsOutline.home,
                      label: "Tambah Rumah",
                      onTap: () => context.push('/warga/tambah-rumah'),
                    ),

                    MenuItemWidget(
                      icon: HeroiconsOutline.buildingLibrary,
                      label: "Daftar Rumah",
                      onTap: () => context.push('/warga/daftar-rumah'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Sirkulasi Warga", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.fromLTRB(12, 12, 12, 40),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 30,
                  children: [
                    MenuItemWidget(
                      icon: HeroiconsOutline.chatBubbleLeftRight,
                      label: "Aspirasi Warga",
                      onTap: () => context.push('/warga/aspirasi'),
                    ),

                    MenuItemWidget(
                      icon: HeroiconsOutline.documentCheck,
                      label: "Penerimaan Warga",
                      onTap: () => context.push('/warga/penerimaan-warga'),
                    ),

                    MenuItemWidget(
                      icon: HeroiconsOutline.userMinus,
                      label: "Tambah Mutasi",
                      onTap: () => context.push('/warga/tambah-mutasi'),
                    ),

                    MenuItemWidget(
                      icon: HeroiconsOutline.archiveBoxXMark,
                      label: "Daftar Mutasi",
                      onTap: () => context.push('/warga/daftar-mutasi'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
