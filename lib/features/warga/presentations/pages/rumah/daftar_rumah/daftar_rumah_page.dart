// lib/features/warga/presentation/pages/daftar_rumah/daftar_rumah_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';

import 'methods/card_rumah.dart';
import 'methods/search.dart';

class DaftarRumahPage extends ConsumerStatefulWidget {
  const DaftarRumahPage({super.key});

  @override
  ConsumerState<DaftarRumahPage> createState() => _DaftarRumahPageState();
}

class _DaftarRumahPageState extends ConsumerState<DaftarRumahPage> {
  @override
  void initState() {
    super.initState();
    // Clear search input ketika halaman dibuka
    Future.microtask(() {
      ref.invalidate(searchRumahInputProvider);
      ref.invalidate(searchRumahKeywordProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allRumahAsync = ref.watch(rumahListProvider);
    final searchResults = ref.watch(searchRumahResultProvider);
    final keyword = ref.watch(searchRumahKeywordProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Daftar Rumah',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: Colors.grey[300]),
          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔍 Search Rumah
                const Search(),

                const SizedBox(height: 20),

                // ===============================
                //  🔥 KONDISI: SEARCH / LIST NORMAL
                // ===============================

                if (keyword.isEmpty)
                  allRumahAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, st) => Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text("Error: $err",
                          style: const TextStyle(color: Colors.red)),
                    ),
                    data: (list) {
                      if (list.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text("Belum ada data rumah."),
                        );
                      }

                      return Column(
                        children: list.map((rumah) {
                          final nama = "${rumah.blok} ${rumah.nomorRumah}";
                          final ditempati = rumah.keluargaId != null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardRumah(
                              namaRumah: nama,
                              ditempati: ditempati,
                              rumahId: rumah.id,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )

                else
                  searchResults.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, st) => Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text("Error: $err",
                          style: const TextStyle(color: Colors.red)),
                    ),
                    data: (list) {
                      if (list.isEmpty) {
                        return const Text(
                          "Tidak ada rumah yang cocok.",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      return Column(
                        children: list.map((rumah) {
                          final nama = "${rumah.blok} ${rumah.nomorRumah}";
                          final ditempati = rumah.keluargaId != null;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardRumah(
                              namaRumah: nama,
                              ditempati: ditempati,
                              rumahId: rumah.id,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
