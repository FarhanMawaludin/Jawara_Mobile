import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/keuangan/presentations/providers/mutasi/mutasi_providers.dart';
import '../pengeluaran/tambah_pengeluaran.dart';
import 'package:go_router/go_router.dart';

class MutasiPage extends ConsumerWidget {
  static const String routeName = '/keuangan/mutasi/mutasi';

  const MutasiPage({
    super.key,
  });

  static GoRoute route() => GoRoute(
        path: routeName,
        builder: (context, state) {
          return const MutasiPage();
        },
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsyncValue = ref.watch(allTransactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Transaksi"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPengeluaranPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: transactionsAsyncValue.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(
              child: Text("Tidak ada transaksi"),
            );
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final t = transactions[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Icon(
                    t.jenis == MutasiType.pemasukan
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: t.jenis == MutasiType.pemasukan
                        ? Colors.green
                        : Colors.red,
                  ),
                  title: Text(t.nama),
                  subtitle: Text(
                    "${t.kategori ?? '-'}\n${t.tanggal.toString().split(' ')[0]}",
                  ),
                  trailing: Text(
                    "Rp ${t.jumlah.toStringAsFixed(0)}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
        error: (error, stackTrace) {
          return Center(
            child: Text("Error: $error"),
          );
        },
      ),
    );
  }
}
