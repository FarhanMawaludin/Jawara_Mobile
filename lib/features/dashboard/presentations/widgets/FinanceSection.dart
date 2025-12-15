import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../keuangan/presentations/providers/mutasi/mutasi_providers.dart';
import '../../../keuangan/domain/entities/mutasi.dart';

class FinanceSection extends ConsumerWidget {
  const FinanceSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTransactionsAsync = ref.watch(allTransactionsProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha((0.1 * 255).round()),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Keuangan Bulan Ini',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              allTransactionsAsync.isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh, size: 20),
                      onPressed: () => ref.invalidate(allTransactionsProvider),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
            ],
          ),
          const SizedBox(height: 16),
          
          allTransactionsAsync.when(
            data: (transaksiList) {
              // Filter transaksi bulan ini
              final now = DateTime.now();
              final thisMonth = transaksiList.where((t) {
                return t.tanggal.year == now.year && 
                       t.tanggal.month == now.month;
              }).toList();

              // Hitung total pemasukan dan pengeluaran bulan ini
              double totalPemasukan = 0;
              double totalPengeluaran = 0;

              for (var transaksi in thisMonth) {
                if (transaksi.jenis == MutasiType.pemasukan) {
                  totalPemasukan += transaksi.jumlah;
                } else if (transaksi.jenis == MutasiType.pengeluaran) {
                  totalPengeluaran += transaksi.jumlah;
                }
              }

              final formatter = NumberFormat.currency(
                locale: 'id_ID',
                symbol: 'Rp ',
                decimalDigits: 0,
              );

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildFinanceItem(
                    Icons.trending_up,
                    Colors.green,
                    'Pemasukan',
                    formatter.format(totalPemasukan),
                  ),
                  Container(height: 40, width: 1, color: Colors.grey[200]),
                  _buildFinanceItem(
                    Icons.trending_down,
                    Colors.red,
                    'Pengeluaran',
                    formatter.format(totalPengeluaran),
                  ),
                ],
              );
            },
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Center(
              child: Column(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Gagal memuat data',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(allTransactionsProvider),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinanceItem(
    IconData icon,
    Color color,
    String label,
    String amount,
  ) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}