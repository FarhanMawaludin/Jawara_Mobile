import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';
import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';

class DetailTagihanPage extends ConsumerWidget {
  final TagihIuran data;
  
  const DetailTagihanPage({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kategoriAsync = ref.watch(kategoriByIdProvider(data.kategoriId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Detail Iuran"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Detail"),
              Tab(text: "Riwayat"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Tab Detail
            _buildDetailTab(context, kategoriAsync),
            
            // Tab Riwayat
            const Center(child: Text("Riwayat belum tersedia")),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTab(BuildContext context, AsyncValue kategoriAsync) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _buildRow("Kode Iuran", "IRT${data.id}"),
          _buildRow("Nama Iuran", data.nama),

          // 🔥 Tampilkan nama kategori
          kategoriAsync.when(
            data: (kategori) => _buildRow(
              "Kategori",
              kategori?.namaKategori ?? "Tidak ditemukan",
            ),
            loading: () => _buildRow("Kategori", "Memuat..."),
            error: (e, _) => _buildRow("Kategori", "Error: $e"),
          ),

          _buildRow(
            "Periode",
            "${data.tanggalTagihan.day}/${data.tanggalTagihan.month}/${data.tanggalTagihan.year}",
          ),
          
          _buildRow(
            "Nominal",
            "Rp ${_formatCurrency(data.jumlah as int)}",
          ),
          
          _buildRow(
            "Status",
            data.statusTagihan,
            color: _getStatusColor(data.statusTagihan),
          ),
          
          _buildRow("Nama KK", data.nama),
          _buildRow("Metode Pembayaran", "Belum tersedia"),
          _buildRow("Alamat", "Belum tersedia"),
          
          const SizedBox(height: 16),

          // TextField untuk alasan penolakan
          const TextField(
            decoration: InputDecoration(
              labelText: "Tulis alasan penolakan...",
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color: color ?? Colors.black87,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  // Helper untuk format currency
  String _formatCurrency(int amount) {
    return amount.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Helper untuk warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'belum bayar':
      case 'pending':
        return Colors.amber;
      case 'lunas':
      case 'sudah bayar':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }
}