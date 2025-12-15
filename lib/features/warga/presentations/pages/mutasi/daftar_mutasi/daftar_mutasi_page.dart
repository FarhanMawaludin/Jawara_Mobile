import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';
import 'package:jawaramobile/features/warga/presentations/providers/mutasi/mutasi_providers.dart';
import 'methods/card_mutasi.dart';
import 'methods/search.dart';

class DaftarMutasiPage extends ConsumerStatefulWidget {
  const DaftarMutasiPage({super.key});

  @override
  ConsumerState<DaftarMutasiPage> createState() => _DaftarMutasiPageState();
}

class _DaftarMutasiPageState extends ConsumerState<DaftarMutasiPage> {
  @override
  void initState() {
    super.initState();
    // Clear search input ketika halaman dibuka
    Future.microtask(() {
      ref.invalidate(searchMutasiInputProvider);
      ref.invalidate(searchMutasiKeywordProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final allMutasiAsync = ref.watch(mutasiListProvider);
    final searchResults = ref.watch(searchMutasiResultProvider);
    final keyword = ref.watch(searchMutasiKeywordProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Daftar Mutasi',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[300], height: 1),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Search(),

                const SizedBox(height: 20),

                if (keyword.isEmpty)
                  allMutasiAsync.when(
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, st) => Padding(
                      padding: const EdgeInsets.only(top: 40),
                      child: Text(
                        "Error: $err",
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    data: (list) {
                      if (list.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text("Belum ada data rumah."),
                        );
                      }

                      return Column(
                        children: list.map((m) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: CardMutasi(
                              namaKeluarga:
                                  m.keluarga?['nama_keluarga'] ??
                                  "Nama Keluarga",
                              pindah: m.jenisMutasi == "pindah_rumah",
                              mutasiId: m.id,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  )
                else
                searchResults.when(
                  loading: () => const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  error: (err, st) => Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      "Error: $err",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  data: (list) {
                    if (list.isEmpty) {
                      return Text(
                          "Tidak ada mutasi yang cocok.",
                          style: TextStyle(color: Colors.grey),
                        );
                    }

                    return Column(
                      children: list.map((m) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: CardMutasi(
                            namaKeluarga:
                                m.keluarga?['nama_keluarga'] ?? "Nama Keluarga",
                            pindah: m.jenisMutasi == "pindah_rumah",
                            mutasiId: m.id,
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
