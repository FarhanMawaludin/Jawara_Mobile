import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'methods/card_warga.dart';
import 'methods/judul_detail.dart';
import 'package:intl/intl.dart';

class DetailWargaPage extends ConsumerWidget {
  final int wargaId;

  const DetailWargaPage({super.key, required this.wargaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wargaAsync = ref.watch(wargaDetailProvider(wargaId));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Detail Warga',
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

        body: wargaAsync.when(
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => Center(child: Text("Error: $err")),
          data: (w) {
            if (w == null)
              return const Center(child: Text("Data tidak ditemukan"));

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    JudulDetail(namaWarga: w.nama),
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
                            "Keluarga",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            w.keluarga?['nama_keluarga'] ??
                                "Tidak ada nama keluarga",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // ======== Card Warga Dinamis ========
                          CardWarga(
                            ttl: w.tanggalLahir != null
                                ? "${w.tempatLahir ?? '-'}, ${DateFormat('dd-MM-yyyy').format(w.tanggalLahir!)}"
                                : (w.tempatLahir ?? "-"),
                            noTelepon: w.noTelp ?? "-",
                            jenisKelamin: w.jenisKelamin ?? "-",
                            agama: w.agama ?? "-",
                            golonganDarah: w.golonganDarah ?? "-",
                            pendidikan: w.pendidikan ?? "-",
                            pekerjaan: w.pekerjaan ?? "-",
                            peranKeluarga: w.roleKeluarga.toString(),
                            statusPenduduk: "Aktif",
                          ),
                        ],
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
