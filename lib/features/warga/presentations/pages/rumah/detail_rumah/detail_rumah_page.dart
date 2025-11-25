import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';
import 'methods/card_rumah.dart';

class DetailRumahPage extends ConsumerWidget {
  final int rumahId;

  const DetailRumahPage({super.key, required this.rumahId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rumahAsync = ref.watch(rumahDetailProvider(rumahId));

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Detail Rumah',
              style: TextStyle(fontWeight: FontWeight.w500)),
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

        body: rumahAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text("Gagal memuat data: $e")),
          data: (rumah) {
            if (rumah == null) {
              return const Center(child: Text("Data rumah tidak ditemukan"));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    // Judul tetap sesuai desain
                    // JudulDetail(
                    //   blok: rumah.blok ?? "-",
                    //   nomorRumah: rumah.nomorRumah ?? "-",
                    // ),

                    const SizedBox(height: 20),

                    // Container tetap sama seperti desainmu
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
                            "Detail Rumah",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                            softWrap: true,
                          ),
                          const SizedBox(height: 12),

                          // CardRumah versi baru (isi dari provider)
                          CardRumah(
                            blok: rumah.blok ?? "-",
                            nomorRumah: rumah.nomorRumah ?? "-",
                            alamatLengkap: rumah.alamatLengkap ?? "-",
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
