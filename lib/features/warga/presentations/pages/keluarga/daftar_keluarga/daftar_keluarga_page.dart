import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga_providers.dart';
import 'methods/card_keluarga.dart';
import 'methods/search.dart';

class DaftarKeluargaPage extends ConsumerWidget {
  const DaftarKeluargaPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wargaAsync = ref.watch(wargaListProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Daftar Keluarga',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
        ),

        body: wargaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text("Error: $e")),
          data: (list) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Search(),
                    const SizedBox(height: 20),

                    // === Render list warga (keluarga) ===
                    ...list.map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CardKeluarga(
                          namaKeluarga:
                              w.keluarga?['nama_keluarga'] ??
                              'Tidak ada nama keluarga',
                          alamat:
                              w.rumah?['alamat_lengkap'] ??
                              'Alamat tidak ada',
                          role: w.roleKeluarga ?? 'Tidak diketahui',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
