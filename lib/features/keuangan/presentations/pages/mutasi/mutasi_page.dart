import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/keuangan/presentations/providers/mutasi/mutasi_providers.dart';
import '../pengeluaran/tambah_pengeluaran.dart';
import 'package:go_router/go_router.dart';

class MutasiPage extends ConsumerWidget {
  static const String routeName = '/keuangan/mutasi/mutasi';

  const MutasiPage({
    super. key,
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
    
    // Definisikan currency formatter
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Transaksi"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Tunggu hasil dari halaman tambah pengeluaran
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahPengeluaranPage()),
          );
          
          // Jika berhasil menambah data, refresh provider
          if (result == true) {
            ref.invalidate(allTransactionsProvider);
            // Jika ada provider saldo, invalidate juga
            // ref.invalidate(saldoProvider);
          }
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
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical:  6),
                child: ListTile(
                  leading:  Icon(
                    t.jenis == MutasiType. pemasukan
                        ? Icons.arrow_downward
                        : Icons.arrow_upward,
                    color: t.jenis == MutasiType. pemasukan
                        ? Colors.green
                        : Colors. red,
                  ),
                  title: Text(t.nama),
                  subtitle: Text(
                    "${t.kategori ?? '-'}\n${t. tanggal.toString().split(' ')[0]}",
                  ),
                  trailing: Text(
                    currencyFormatter.format(t.jumlah),
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