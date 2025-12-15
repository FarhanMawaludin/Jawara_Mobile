import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/pemasukanlainnya/pemasukanlainnya_providers.dart';

class PemasukanLainPage extends ConsumerWidget {
  const PemasukanLainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pemasukanList = ref.watch(pemasukanNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pemasukan Lain"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF635BFF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_alt_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),

      body: pemasukanList.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text("Error: $err")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Tidak ada pemasukan lainnya"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final item = list[index];

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.namaPemasukan,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          const Icon(Icons.wallet_rounded,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          const Text("Pendapatan Lainnya"),
                          const SizedBox(width: 10),
                          const Icon(Icons.calendar_today,
                              size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            "${item.tanggalPemasukan.day}-${item.tanggalPemasukan.month}-${item.tanggalPemasukan.year}",
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Rp ${item.jumlah.toStringAsFixed(0)}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Color(0xFF4F46E5),
                        ),
                      ),

                      const SizedBox(height: 12),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => context.push(
                            '/keuangan/pemasukan-lain/detail/${item.id}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text("Detail"),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
