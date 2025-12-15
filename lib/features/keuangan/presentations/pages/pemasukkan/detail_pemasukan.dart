import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pemasukanlainnya/pemasukanlainnya_providers.dart';

class PemasukanLainDetailPage extends ConsumerWidget {
  final int id;

  const PemasukanLainDetailPage({
    super.key,
    required this.id,
  });

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailState = ref.watch(pemasukanDetailNotifierProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemasukan Lain"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: detailState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text("Error: $e")),
        data: (data) {
          if (data == null) {
            return const Center(child: Text("Data tidak ditemukan"));
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRow("Nama Pemasukan", data.namaPemasukan),
                    _buildRow("Kategori", data.kategoriPemasukan.toString()),
                    _buildRow("Kategori Dana", "-"),
                    _buildRow(
                      "Tanggal Transaksi",
                      "${data.tanggalPemasukan.day}-${data.tanggalPemasukan.month}-${data.tanggalPemasukan.year}",
                    ),
                    _buildRow("Nominal", "Rp ${data.jumlah.toStringAsFixed(0)}"),
                    _buildRow("Tanggal Terverifikasi", "-"),
                    _buildRow("Verifikator", "-"),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
