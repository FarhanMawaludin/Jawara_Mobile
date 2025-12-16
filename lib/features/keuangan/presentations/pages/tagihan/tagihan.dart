import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/features/keuangan/presentations/providers/iurandetail/iurandetail_providers.dart';
import 'package:jawaramobile/features/keuangan/presentations/widgets/pdf/tagihan_pdf_generator.dart';

class TagihanPage extends ConsumerWidget {
  final int keluargaId;

  const TagihanPage({super.key, required this.keluargaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint('🏠 TagihanPage opened with keluargaId: $keluargaId');
    
    final asyncTagihan = ref.watch(iuranDetailByKeluargaProvider(keluargaId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tagihan Keluarga"),
        centerTitle: true,
        actions:  [
          // Tombol Refresh
          IconButton(
            onPressed: () {
              debugPrint('🔄 Refreshing data for keluargaId: $keluargaId');
              ref.invalidate(iuranDetailByKeluargaProvider(keluargaId));
            },
            icon:  const Icon(Icons.refresh),
            tooltip: 'Refresh Data',
          ),
          // Tombol Print
          IconButton(
            onPressed: () {
              asyncTagihan.whenData((list) {
                if (list.isNotEmpty) {
                  TagihanPdfGenerator. printPDF(list);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Tidak ada data untuk dicetak'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              });
            },
            icon: const Icon(Icons.print),
            tooltip: 'Print PDF',
          ),
          // Tombol Filter
          IconButton(
            onPressed:  () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filter belum tersedia'),
                ),
              );
            },
            icon:  const Icon(Icons.filter_list),
            tooltip: 'Filter',
          ),
        ],
      ),

      body: asyncTagihan.when(
        loading: () {
          debugPrint('🔄 Loading data for keluargaId: $keluargaId');
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Memuat data tagihan...'),
              ],
            ),
          );
        },
        
        error: (e, st) {
          debugPrint('❌ Error loading data: $e');
          debugPrint('📍 Stack trace: $st');
          return Center(
            child:  Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Error: $e",
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors. red),
                  ),
                  const SizedBox(height:  16),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.invalidate(iuranDetailByKeluargaProvider(keluargaId));
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        },
        
        data: (iuranList) {
          debugPrint('✅ Data loaded: ${iuranList.length} items');
          if (iuranList.isNotEmpty) {
            debugPrint('📋 First item: ${iuranList.first}');
          }

          if (iuranList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.receipt_long_outlined,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Belum ada tagihan",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Keluarga ID: $keluargaId",
                      style:  const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        ref.invalidate(iuranDetailByKeluargaProvider(keluargaId));
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor:  Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(iuranDetailByKeluargaProvider(keluargaId));
              await ref.read(iuranDetailByKeluargaProvider(keluargaId).future);
            },
            child: ListView. builder(
              padding: const EdgeInsets.all(16),
              itemCount: iuranList.length,
              itemBuilder: (context, index) {
                final item = iuranList[index];
                final tagihan = item.tagihIuranData; // ✅ UBAH: Dari tagihIuran jadi tagihIuranData

                debugPrint('📄 Rendering item $index: ${item.id}');

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child:  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Nama Tagihan
                        Text(
                          tagihan?.nama ??  'Nama tidak tersedia',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Info Kategori dan Tanggal
                        Row(
                          children:  [
                            const Icon(Icons.category, size: 16, color: Colors.grey),
                            const SizedBox(width:  4),
                            Text(
                              'Kategori:  ${tagihan?.kategoriId. toString() ?? '-'}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            const SizedBox(width: 16),
                            const Icon(Icons.date_range, size: 16, color:  Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              tagihan != null
                                  ? "${tagihan.tanggalTagihan.day}/${tagihan.tanggalTagihan. month}/${tagihan.tanggalTagihan.year}"
                                  : '-',
                              style: const TextStyle(fontSize:  12),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // Jumlah Tagihan
                        Text(
                          "Rp ${_formatCurrency((tagihan?.jumlah ??  0).toInt())}",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Status dan Tombol Detail
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: _getStatusColor(
                                  item. statusPembayaran,
                                ).withOpacity(0.1),
                                border: Border.all(
                                  color: _getStatusColor(
                                    item.statusPembayaran,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets. symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: Text(
                                _getStatusLabel(item.statusPembayaran),
                                style: TextStyle(
                                  color: _getStatusColor(
                                    item.statusPembayaran,
                                  ),
                                  fontWeight:  FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 10,
                                ),
                              ),
                              onPressed: () {
                                debugPrint('🔍 Opening detail for item: ${item. id}');
                                context. push(
                                  '/keuangan/tagihan/detail',
                                  extra: item,
                                );
                              },
                              child: const Text("Detail"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
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

  // Helper untuk status label
  String _getStatusLabel(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return 'LUNAS';
      case 'belum_bayar':
        return 'BELUM BAYAR';
      case 'terlambat': 
        return 'TERLAMBAT';
      default:
        return status.toUpperCase();
    }
  }

  // Helper untuk status color
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'lunas':
        return Colors.green;
      case 'belum_bayar':
        return Colors. orange;
      case 'terlambat':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}