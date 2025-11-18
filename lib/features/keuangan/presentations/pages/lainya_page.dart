import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class LainnyaPage extends StatelessWidget {
  const LainnyaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lainnya"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SectionTitle(title: "Pemasukkan"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': Icons.category, 'label': 'Kategori Iuran', 'route': '/keuangan/iuran/kategori-iuran'},
              {'icon': Icons.request_quote, 'label': 'Tagih Iuran', 'route': '/tagih-iuran'},
              {'icon': Icons.receipt_long, 'label': 'Tagihan', 'route': '/keuangan/tagihan/tagihan'},
              {'icon': Icons.trending_up, 'label': 'Pemasukkan Lain', 'route': '/keuangan/pemasukan-lain'},
              {'icon': Icons.add_circle, 'label': 'Tambah Pemasukkan', 'route': '/keuangan/pemasukkan/tambah-pemasukkan'},
            ]),
            SizedBox(height: 20),

            SectionTitle(title: "Pengeluaran"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': Icons.trending_down, 'label': 'Daftar Pengeluaran'},
              {'icon': Icons.add_circle, 'label': 'Tambah Pengeluaran'},
            ]),
            SizedBox(height: 20),

            SectionTitle(title: "Laporan Keuangan"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': Icons.trending_up, 'label': 'Laporan Pemasukkan'},
              {'icon': Icons.trending_down, 'label': 'Laporan Pengeluaran'},
              {'icon': Icons.picture_as_pdf, 'label': 'Cetak Laporan'},
              {'icon': Icons.show_chart, 'label': 'Statistik', 'route': '/keuangan/statistik/statistik'},
            ]),
            SizedBox(height: 20),

            SectionTitle(title: "Channel Transfer"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': Icons.credit_card, 'label': 'Daftar Channel'},
              {'icon': Icons.add_card, 'label': 'Tambah Channel'},
            ]),
          ],
        ),
      ),
    );
  }
}

// ==================== COMPONENTS ====================
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
        fontSize: 18,
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const MenuCard({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisExtent: 80,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          final route = item['route'];
          return InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              if (route is String && route.isNotEmpty) {
                context.push(route);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Route untuk "${item['label']}" belum tersedia')),
                );
              }
            },

            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(item['icon'], color: Colors.deepPurple),
                ),
                const SizedBox(height: 5),
                Text(
                  item['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 11),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}