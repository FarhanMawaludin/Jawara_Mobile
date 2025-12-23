import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/router/router.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/keuangan/presentations/providers/mutasi/mutasi_providers.dart';

void main() {
  runApp(MaterialApp.router(routerConfig: router));
}

class KeuanganPage extends ConsumerWidget {
  const KeuanganPage({super.key});

  String _formatCurrency(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = [
      {
        'icon': CupertinoIcons.qrcode,
        'label': 'Kategori Iuran',
        'route': '/keuangan/iuran/kategori-iuran',
        'warna': Colors.black,
      },
      {
        'icon': CupertinoIcons.creditcard,
        'label': 'Tagih Iuran',
        'route': '/keuangan/tagihan/tagih-iuran',
        'warna': Colors.black,
      },
      {
        'icon': CupertinoIcons.doc,
        'label': 'Tagihan',
        'route': '/keuangan/tagihan/tagihan/45',
        'warna': Colors.black,
      },
      {
        'icon': CupertinoIcons.arrow_down_left,
        'label': 'Pemasukan Lain',
        'route': '/keuangan/pemasukan-lain',
        'warna': Colors.green,
      },
      {
        'icon': CupertinoIcons.add,
        'label': 'Tambah Pemasukan',
        'route': '/keuangan/pemasukkan/tambah-pemasukkan',
        'warna': Colors.green,
      },
      {
        'icon': CupertinoIcons.arrow_right_arrow_left,
        'label': 'Mutasi Keuangan',
        'route': '/keuangan/mutasi/mutasi',
        'warna': Colors.black,
      },
      {
        'icon': CupertinoIcons.add,
        'label': 'Tambah Pengeluaran',
        'route': '/keuangan/pengeluaran/tambah-pengeluaran',
        'warna': Colors.red,
      },
      {
        'icon': CupertinoIcons.bars,
        'label': 'Lainnya',
        'route': '/keuangan/lainnya',
        'warna': Colors.black,
      },
    ];

    final transaksiAsyncValue = ref.watch(allTransactionsProvider);
    final saldoAsyncValue = ref.watch(totalSaldoProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header dengan Saldo Dinamis
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 25),
                  const Text(
                    "Saldo",
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                  saldoAsyncValue.when(
                    data: (saldo) => Text(
                      "Rp. ${_formatCurrency(saldo)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    loading: () => const Text(
                      "Rp. 0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    error: (_, __) => const Text(
                      "Rp. 0",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                            color: item['warna'] as Color,
                          ),
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
                child: Text(
                  "Transaksi Terakhir",
                  style: TextStyle(
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Transaksi List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: transaksiAsyncValue.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    Center(child: Text("Error: $error")),
                data: (transaksiList) => transaksiList.isEmpty
                    ? const Center(child: Text("Tidak ada transaksi"))
                    : Column(
                        children: transaksiList.take(5).map((t) {
                          return InkWell(
                            onTap: () => context.push('/transaksi/${t.nama}'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        (t.jenis == MutasiType.pemasukan)
                                            ? CupertinoIcons.arrow_down_left
                                            : CupertinoIcons.arrow_up_right,
                                        color: t.jenis == MutasiType.pemasukan
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                      const SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            t.nama,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            t.kategori ?? '-',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "Rp ${_formatCurrency(t.jumlah)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
