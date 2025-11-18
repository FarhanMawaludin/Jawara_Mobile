import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PemasukanLainDetailPage extends StatelessWidget {
  const PemasukanLainDetailPage({super.key});

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemasukan Lain"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
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
                _buildRow("Nama Pemasukan", "IRI75458A501"),
                _buildRow("Kategori", "Mingguan"),
                _buildRow("Kategori Dana", "Dana Bantuan Pemerintah"),
                _buildRow("Tanggal Transaksi", "8 Oktober 2025"),
                _buildRow("Nominal", "Rp 30.000"),
                _buildRow("Tanggal Terverifikasi", "-"),
                _buildRow("Verifikator", "Admin Jawara"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
