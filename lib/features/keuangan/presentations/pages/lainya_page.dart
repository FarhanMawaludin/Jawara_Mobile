import 'package:flutter/cupertino.dart';
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
              {'icon': CupertinoIcons.qrcode_viewfinder,'label': 'Kategori Iuran', 'route': '/keuangan/iuran/kategori-iuran', 'color': Colors.black},
              {'icon': CupertinoIcons.creditcard, 'label': 'Tagih Iuran', 'route': '/keuangan/iuran/tambah-iuran', 'color': Colors.black},
              {'icon': CupertinoIcons.doc_text, 'label': 'Tagihan', 'route': '/keuangan/tagihan/tagihan', 'color': Colors.black},
              {'icon': CupertinoIcons.arrow_down_left, 'label': 'Pemasukkan Lain', 'route': '/keuangan/pemasukan-lain', 'color': Colors.green},
              {'icon': CupertinoIcons.add_circled, 'label': 'Tambah Pemasukkan', 'route': '/keuangan/pemasukkan/tambah-pemasukkan', 'color': Colors.green},
            ]),
            SizedBox(height: 20),

            SectionTitle(title: "Pengeluaran"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': CupertinoIcons.arrow_up_right, 'label': 'Daftar Pengeluaran', 'route': '/daftar-pengeluaran', 'color': Colors.red},
              {'icon': CupertinoIcons.add_circled, 'label': 'Tambah Pengeluaran', 'route': '/keuangan/pengeluaran/tambah-pengeluaran', 'color': Colors.red},
            ]),
            SizedBox(height: 20),

            SectionTitle(title: "Laporan Keuangan"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': CupertinoIcons.arrow_right_arrow_left, 'label': 'Mutasi','route': '/keuangan/transaction/mutasi ' ,'color': Colors.black},
              {'icon': CupertinoIcons.printer, 'label': 'Cetak Laporan', 'color': Colors.black},
              {'icon': CupertinoIcons.chart_bar, 'label': 'Statistik', 'route': '/keuangan/statistik/statistik', 'color': Colors.black},
            ]),
            SizedBox(height: 20),

            SectionTitle(title: "Channel Transfer"),
            SizedBox(height: 10),
            MenuCard(items: [
              {'icon': CupertinoIcons.rectangle_stack, 'label': 'Daftar Channel', 'color': Colors.black},
              {'icon': CupertinoIcons.creditcard, 'label': 'Tambah Channel', 'color': Colors.black},
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
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 24,
                  ),
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