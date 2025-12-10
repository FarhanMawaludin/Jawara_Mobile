import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';

class KategoriIuranPage extends ConsumerWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kategoriState = ref.watch(kategoriIuranNotifierProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kategori Iuran'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
     body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurple.shade200),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.deepPurple),
                      SizedBox(width: 8),
                      Text(
                        "Iuran Bulanan:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text("Dibayar setiap bulan sekali secara rutin."),
                  SizedBox(height: 8),
                  Text(
                    "Iuran Khusus:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Dibayar sesuai kebutuhan tertentu, misalnya acara khusus, renovasi, dsb."),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () => context.push('/keuangan/iuran/tambah-iuran'),
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Iuran"),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: kategoriState.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text("Error: $error"),
                ),
                data: (dataIuran) => dataIuran.isEmpty
                    ? const Center(
                        child: Text("Tidak ada kategori iuran"),
                      )
                    : ListView.builder(
                        itemCount: dataIuran.length,
                        itemBuilder: (context, index) {
                          final item = dataIuran[index];
                          return Card(
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.receipt_long),
                              ),
                              title: Text(item.namaKategori),
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Edit ${item.namaKategori}"),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    ref
                                        .read(
                                            kategoriIuranNotifierProvider
                                                .notifier)
                                        .deleteKategoriById(item.id);
                                  }
                                },
                                itemBuilder: (BuildContext context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text('Edit'),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text('Hapus'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}