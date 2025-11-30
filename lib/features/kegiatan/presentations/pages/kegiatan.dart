import 'package:flutter/material.dart';
import 'widgets/statistics_card.dart';
import 'widgets/menu_grid.dart';


class KegiatanPage extends StatelessWidget {
  const KegiatanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.only(
            top: 60,
            left: 16.0,
            right: 16.0,
            bottom: 16.0,
          ),
          child: Column(
            children: [
              // Statistics Card
              const StatisticsCard(
                totalKegiatan: 72,
                selesai: 10,
                hariIni: 2,
                akanDatang: 60,
              ),
              const SizedBox(height: 24),
              
              // Menu Grid
              const MenuGrid(),
              
              const SizedBox(height: 16),
           
            ],
          ),
        ),
      ),
    );
  }
}