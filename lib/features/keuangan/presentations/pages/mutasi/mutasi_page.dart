import 'package:flutter/material.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/transaction.dart';
import '../pengeluaran/tambah_pengeluaran.dart';

class MutasiPage extends StatelessWidget {
  final List<Transaction> transactions;

  const MutasiPage({
    super.key,
    required this.transactions,
  });

  @override
  Widget build(BuildContext context) {
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
      body: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final t = transactions[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Icon(
                t.jenis == TransactionType.pemasukan
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: t.jenis == TransactionType.pemasukan
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
      ),
    );
  }
}
