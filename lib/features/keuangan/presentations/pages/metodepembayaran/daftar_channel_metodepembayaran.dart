import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/metodepembayaran/metodepembayaran_providers.dart';
import '../../../data/models/metodepembayaran_model.dart';

class DaftarChannelMetodepembayaran extends ConsumerWidget {
  const DaftarChannelMetodepembayaran({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metodeAsync = ref.watch(metodePembayaranProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Daftar Channel Pembayaran"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/keuangan/metodepembayaran/tambah-metodepembayaran');
        },
        child: const Icon(Icons.add),
      ),
      body: metodeAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text("Error: $err")),
        data: (list) {
          if (list.isEmpty) {
            return const Center(child: Text("Belum ada channel pembayaran"));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final MetodePembayaranModel item = list[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(item.namaMetode),
                  subtitle: Text("Tipe: ${item.tipe}"),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      if (value == 'edit') {
                        // TODO: navigate ke edit form
                      } else if (value == 'hapus') {
                        _hapus(context, ref, item.id);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 18),
                            SizedBox(width: 8),
                            Text("Edit"),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'hapus',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18),
                            SizedBox(width: 8),
                            Text("Hapus"),
                          ],
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

  
  Future<void> _hapus(BuildContext context, WidgetRef ref, int id) async {
    final repo = ref.read(metodePembayaranRepositoryProvider);

    bool success = false;
    try {
      await repo.deleteMetode(id);
      success = true;
    } catch (_) {
      success = false;
    }

    // Mencegah use_build_context_synchronously
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? "Berhasil dihapus" : "Gagal menghapus"),
      ),
    );

    // Refresh provider
    ref.invalidate(metodePembayaranProvider);
  }
}
