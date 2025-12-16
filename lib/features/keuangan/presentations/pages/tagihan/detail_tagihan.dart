import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/keuangan/data/models/iurandetail_model.dart';
import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';

class DetailTagihanPage extends ConsumerWidget {
  final IuranDetail data;
  
  const DetailTagihanPage({super.key, required this.data});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ✅ Ambil data tagihan dari nested object
    final tagihan = data.tagihIuranData;
    
    // ✅ Handle kalau tagihIuranData null
    if (tagihan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Error")),
        body: const Center(
          child: Text('Data tagihan tidak lengkap'),
        ),
      );
    }
    
    // ✅ Gunakan kategoriId dari tagihan
    final kategoriAsync = ref.watch(kategoriByIdProvider(tagihan.kategoriId));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:  const Text("Detail Iuran"),
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
            _buildDetailTab(context, kategoriAsync, tagihan),
            
            // Tab Riwayat
            const Center(child: Text("Riwayat belum tersedia")),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailTab(
    BuildContext context, 
    AsyncValue kategoriAsync,
    dynamic tagihan, // ✅ Tambah parameter tagihan
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: [
          _buildRow("Kode Iuran", "IRT${data.id}"),
          _buildRow("Nama Iuran", tagihan.nama ??  '-'), // ✅ Dari tagihan

          // 🔥 Tampilkan nama kategori
          kategoriAsync.when(
            data: (kategori) => _buildRow(
              "Kategori",
              kategori?.namaKategori ?? "Tidak ditemukan",
            ),
            loading: () => _buildRow("Kategori", "Memuat..."),
            error: (e, _) => _buildRow("Kategori", "Error:  $e"),
          ),

          _buildRow(
            "Periode",
            tagihan.tanggalTagihan != null
                ? "${tagihan. tanggalTagihan! .day}/${tagihan.tanggalTagihan!.month}/${tagihan.tanggalTagihan!.year}"
                :  '-',
          ),
          
          _buildRow(
            "Nominal",
            "Rp ${_formatCurrency(tagihan.jumlah ??  0)}", // ✅ Dari tagihan
          ),
          
          _buildRow(
            "Status",
            tagihan.statusTagihan ?? 'Belum_Bayar', // ✅ Dari tagihan
            color: _getStatusColor(tagihan.statusTagihan ??  ''),
          ),
          
          _buildRow("Nama KK", tagihan.nama ?? '-'),
          _buildRow("Metode Pembayaran", data.metodePembayaranId?.toString() ?? "Belum tersedia"),
          _buildRow("Alamat", "Belum tersedia"),
          
          const SizedBox(height: 16),

        ],
      ),
    );
  }

  Widget _buildRow(String title, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment. spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight. w600),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                color:  color ?? Colors.black87,
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
  String _formatCurrency(num amount) { // ✅ Ubah dari int ke num
    return amount.toInt().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  // Helper untuk warna status
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'Belum Bayar': 
      case 'belum_bayar':
      case 'pending':
      case 'belumbayar':
        return Colors.amber;
      case 'lunas':
      case 'sudah bayar':
      case 'sudah_bayar':
      case 'sudahbayar':
        return Colors.green;
      case 'ditolak':
        return Colors.red;
      default:
        return Colors.black87;
    }
  }
}