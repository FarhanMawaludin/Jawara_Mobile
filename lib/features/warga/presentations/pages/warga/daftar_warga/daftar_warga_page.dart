import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons_flutter/heroicons_flutter.dart';

import 'methods/search.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'methods/card_warga.dart';

class DaftarWargaPage extends ConsumerStatefulWidget {
  const DaftarWargaPage({super.key});

  @override
  ConsumerState<DaftarWargaPage> createState() => _DaftarWargaPageState();
}

class _DaftarWargaPageState extends ConsumerState<DaftarWargaPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.invalidate(searchInputProvider);
      ref.invalidate(searchKeywordProvider);
    });
  }

  @override
  Widget build(BuildContext context) {
    final wargaAsync = ref.watch(wargaListProvider);
    final searchResults = ref.watch(searchWargaProvider);
    final keyword = ref.watch(searchKeywordProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,

        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(HeroiconsMini.arrowLeft),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Daftar Warga',
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
                const Search(),
                const SizedBox(height: 20),

                if (keyword.isEmpty) ...[
                  wargaAsync.when(
                    data: (list) => Column(
                      children: list.map((w) {
                        return CardWarga(
                          nama: w.nama,
                          keluargaNama: "Keluarga ${w.nama}",
                          isVerified: true,
                          wargaId: w.id,
                        );
                      }).toList(),
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, _) => Text(
                      "Error: $err",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ] else ...[
                  searchResults.when(
                    data: (list) {
                      if (list.isEmpty) {
                        return const Text(
                          "Tidak ada warga yang cocok.",
                          style: TextStyle(color: Colors.grey),
                        );
                      }

                      return Column(
                        children: list.map((w) {
                          return CardWarga(
                            nama: w.nama,
                            keluargaNama: "Keluarga ${w.nama}",
                            isVerified: true,
                            wargaId: w.id,
                          );
                        }).toList(),
                      );
                    },
                    loading: () => const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (err, _) => Text(
                      "Error: $err",
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
