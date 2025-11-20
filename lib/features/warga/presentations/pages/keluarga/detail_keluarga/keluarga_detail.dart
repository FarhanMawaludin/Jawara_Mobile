import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'methods/card_anggota_keluarga.dart';
import 'methods/judul_detail.dart';

class KeluargaDetail extends ConsumerWidget {
  final int keluargaId;

  const KeluargaDetail({super.key, required this.keluargaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wargaAsync = ref.watch(wargaListProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Detail Keluarga',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: wargaAsync.when(
            data: (wargaList) {
              final anggotaKeluarga = wargaList
                  .where((w) => w.keluargaId == keluargaId)
                  .toList();
              if (anggotaKeluarga.isEmpty) {
                return const Center(child: Text("Tidak ada anggota keluarga"));
              }

              final kepalaKeluarga = anggotaKeluarga
                  .first; // asumsi kepala keluarga adalah pertama

              return SingleChildScrollView(
                child: Column(
                  children: [
                    JudulDetail(
                      namaKeluarga:
                          kepalaKeluarga.keluarga?['nama_keluarga'] ??
                          'Tidak ada nama keluarga',
                      alamat:
                          kepalaKeluarga.rumah?['alamat_lengkap'] ??
                          'Alamat tidak ada',
                      status: kepalaKeluarga.status ?? 'Tidak diketahui',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!, width: 1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kepala Keluarga",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            kepalaKeluarga.nama,
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 18),
                          // tampilkan semua anggota keluarga
                          ...anggotaKeluarga
                              .map((w) => CardAnggotaKeluarga(warga: w))
                              .toList(),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text("Error: $e")),
          ),
        ),
      ),
    );
  }
}
