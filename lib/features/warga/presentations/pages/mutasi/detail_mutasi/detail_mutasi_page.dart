import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:jawaramobile/features/warga/presentations/providers/mutasi/mutasi_providers.dart';
import 'methods/card_alasan.dart';
import 'methods/card_mutasi.dart';
import 'methods/judul_detail.dart';

class DetailMutasiPage extends ConsumerWidget {
  final int mutasiId;

  const DetailMutasiPage({super.key, required this.mutasiId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mutasiDetailAsync = ref.watch(mutasiDetailProvider(mutasiId));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Detail Mutasi',
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
        body: mutasiDetailAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("Gagal memuat data: $e")),
          data: (mutasi) {
            if (mutasi == null) {
              return const Center(child: Text("Data mutasi tidak ditemukan"));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    JudulDetail(namaKeluarga: mutasi.keluarga?['nama_keluarga'], pindah: mutasi.jenisMutasi == 'pindah_rumah'),
                    SizedBox(height: 20),
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
                            "Detail Mutasi",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 12),
                          CardMutasi(
                            alamatLama: mutasi.rumah?['alamat_lengkap'] ?? "-",
                            alamatBaru: mutasi.rumah?['alamat_lengkap'] ?? "-",
                            tanggalMutasi: formatTanggal(mutasi.tanggalMutasi),
                          ),
                          const SizedBox(height: 12),
                          CardAlasan(
                            alasanMutasi: mutasi.alasanMutasi.toString(),
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

String formatTanggal(DateTime? date) {
  if (date == null) return "-";
  return DateFormat("dd MMM yyyy").format(date);
}