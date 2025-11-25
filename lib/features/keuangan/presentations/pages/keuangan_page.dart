import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/router/router.dart';


void main() {
  runApp(MaterialApp.router(routerConfig: router,
  ));
}

class KeuanganPage extends StatelessWidget {
  const KeuanganPage({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      {'icon': CupertinoIcons.qrcode, 'label': 'Kategori Iuran', 'route': '/keuangan/iuran/kategori-iuran', 'warna': Colors.black},
      {'icon': CupertinoIcons.creditcard, 'label': 'Tagih Iuran', 'route': '/keuangan/iuran/tambah-iuran', 'warna': Colors.black},
      {'icon': CupertinoIcons.doc, 'label': 'Tagihan', 'route': '/keuangan/tagihan/tagihan', 'warna': Colors.black},
      {'icon': CupertinoIcons.arrow_down_left, 'label': 'Pemasukan Lain', 'route': '/keuangan/pemasukan-lain', 'warna': Colors.green},
      {'icon': CupertinoIcons.add, 'label': 'Tambah Pemasukan', 'route': '/keuangan/pemasukkan/tambah-pemasukkan', 'warna': Colors.green},
      {'icon': CupertinoIcons.arrow_up_right, 'label': 'Daftar Pengeluaran', 'route': '/daftar-pengeluaran', 'warna': Colors.red},
      {'icon': CupertinoIcons.add, 'label': 'Tambah Pengeluaran', 'route': '/tambah-pengeluaran', 'warna': Colors.red},
      {'icon': CupertinoIcons.bars, 'label': 'Lainnya', 'route': '/keuangan/lainnya', 'warna': Colors.black},
    ];

    final transaksi = [
      {'nama': 'Dimas', 'keterangan': 'Pemeliharaan Fasilitas', 'jumlah': 2112, 'warna': Colors.red},
      {'nama': 'Nafa', 'keterangan': 'Pemeliharaan Fasilitas', 'jumlah': 10000, 'warna': Colors.red},
      {'nama': 'Subandi', 'keterangan': 'Dana Bantuan Pemerintah', 'jumlah': 500000, 'warna': Colors.green},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7A4FF2), Color(0xFF5D2EE7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  SizedBox(height: 25),
                  Text("Saldo", style: TextStyle(color: Colors.white, fontSize: 14)),
                  Text(
                    "Rp. 50.000.000",
                    style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu Grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: menuItems.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  return InkWell(
                    onTap: () {
                      if (item['route'] != null) {
                        context.push(item['route'] as String);
                      }
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.white,
                          child: Icon(
                            item['icon'] as IconData?, 
                            color:  item['warna'] as Color),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['label'] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 11),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 25),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Transaksi Terakhir",
                    style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 10),

            // Transaksi List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: transaksi.map((t) {
                  return InkWell(
                    onTap: () => context.push('/transaksi/${t['nama']}'),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(children: [
                              Icon(
                                (t['warna'] == Colors.green)
                                  ? CupertinoIcons.arrow_down_left 
                                  : CupertinoIcons.arrow_up_right,
                                color: t['warna'] as Color,
                                ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t['nama'].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(t['keterangan'].toString(),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ]),
                          Text(
                            "Rp ${t['jumlah']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
