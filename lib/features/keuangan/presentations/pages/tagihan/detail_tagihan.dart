import 'package:flutter/material.dart';

class DetailTagihanPage extends StatelessWidget {
  final Map<String, dynamic>? data;
  const DetailTagihanPage({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Iuran"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Detail"),
              Tab(text: "Riwayat"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  _buildRow("Kode Iuran", "IRT75458AB501"),
                  _buildRow("Nama Iuran", data?["kategori"] ?? "-"),
                  _buildRow("Kategori", "Iuran Khusus"),
                  _buildRow("Periode", "8 Oktober 2025"),
                  _buildRow("Nominal", "Rp 30.000"),
                  _buildRow("Status", "unpaid", color: Colors.amber),
                  _buildRow("Nama KK", "Keluarga Habibie Ed Dien"),
                  _buildRow("Metode Pembayaran", "Belum tersedia"),
                  _buildRow("Alamat", "Blok A49"),
                  const SizedBox(height: 16),
                  const TextField(
                    decoration: InputDecoration(
                      labelText: "Tulis alasan penolakan...",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const Center(child: Text("Riwayat belum tersedia")),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: TextStyle(color: color ?? Colors.black87)),
        ],
      ),
    );
  }
}
