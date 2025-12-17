import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/ketegoriiuran/ketegoriiuran_providers.dart';

class KategoriIuranPage extends ConsumerWidget {
  const KategoriIuranPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kategoriState = ref. watch(kategoriIuranNotifierProvider);
    
    return Scaffold(
      appBar:  AppBar(
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
              child:  const Column(
                crossAxisAlignment:  CrossAxisAlignment.start,
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
                    style:  TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                      "Dibayar sesuai kebutuhan tertentu, misalnya acara khusus, renovasi, dsb."),
                ],
              ),
            ),
            const SizedBox(height:  16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ✅ UBAH: Route ke halaman tambah kategori (bukan tagih iuran)
                ElevatedButton.icon(
                  onPressed: () => context.push('/keuangan/iuran/tambah-kategori-iuran'),
                  icon: const Icon(Icons.add),
                  label: const Text("Tambah Kategori"), // ✅ UBAH: Label jadi "Tambah Kategori"
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons. filter_list),
                  label: const Text("Filter"),
                ),
              ],
            ),
            const SizedBox(height:  16),
            Expanded(
              child: kategoriState. when(
                loading: () => const Center(
                  child:  CircularProgressIndicator(),
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
                                child: const Icon(Icons. receipt_long),
                              ),
                              title: Text(item.namaKategori),
                              subtitle: Text(
                                '${item.kategoriIuran} • Rp ${item.nominal.toStringAsFixed(0)}', // ✅ Tampilkan info kategori dan nominal
                              ),
                              trailing: PopupMenuButton(
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    ScaffoldMessenger. of(context).showSnackBar(
                                      SnackBar(
                                        content:  Text("Edit ${item.namaKategori}"),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    if (item.id != null) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext dialogContext) {
                                          return AlertDialog(
                                            title: const Text('Konfirmasi Hapus'),
                                            content: Text(
                                              'Apakah Anda yakin ingin menghapus "${item.namaKategori}"?',
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(dialogContext),
                                                child: const Text('Batal'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator. pop(dialogContext);
                                                  ref
                                                      .read(kategoriIuranNotifierProvider.notifier)
                                                      .deleteKategoriById(item.id!);
                                                  
                                                  ScaffoldMessenger. of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text('${item.namaKategori} berhasil dihapus'),
                                                    ),
                                                  );
                                                },
                                                child: const Text(
                                                  'Hapus',
                                                  style:  TextStyle(color: Colors.red),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                      ScaffoldMessenger. of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('ID kategori tidak valid'),
                                        ),
                                      );
                                    }
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