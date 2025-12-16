import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'methods/card_keluarga.dart';
import 'methods/search.dart';

class DaftarKeluargaPage extends ConsumerStatefulWidget {
  const DaftarKeluargaPage({super.key});

  @override
  ConsumerState<DaftarKeluargaPage> createState() => _DaftarKeluargaPageState();
}

class _DaftarKeluargaPageState extends ConsumerState<DaftarKeluargaPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(searchInputProvider.notifier).state = "";
      ref.read(searchKeywordProvider.notifier).state = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    final keyword = ref.watch(searchKeywordProvider);

    final wargaAsync = ref.watch(
      keyword.isEmpty ? keluargaListProvider : searchWargaProvider,
    );

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
          elevation: 0,
          backgroundColor: Colors.white,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Colors.grey[300]),
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
                    const Search(),
                    const SizedBox(height: 20),

                    if (keyword.isNotEmpty && list.isEmpty)
                      const Text(
                        "Tidak ditemukan...",
                        style: TextStyle(color: Colors.grey),
                      ),

                    ...list.map(
                      (w) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: CardKeluarga(
                          keluargaId: w.keluargaId,
                          namaKeluarga:
                              w.keluarga?['nama_keluarga'] ??
                              'Tidak ada nama keluarga',
                          alamat: w.rumah?['alamat_lengkap'] != null
                              ? "${w.rumah?['alamat_lengkap']}, Blok ${w.rumah?['blok'] ?? '-'} No. ${w.rumah?['nomor_rumah'] ?? '-'}"
                              : "Alamat tidak ada",
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
