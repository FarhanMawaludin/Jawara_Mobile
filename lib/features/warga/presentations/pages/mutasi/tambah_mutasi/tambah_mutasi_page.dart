import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/features/warga/data/models/mutasi_model.dart';
import 'package:jawaramobile/features/warga/presentations/providers/mutasi/mutasi_providers.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';

class TambahMutasiPage extends ConsumerStatefulWidget {
  const TambahMutasiPage({super.key});

  @override
  ConsumerState<TambahMutasiPage> createState() => _TambahMutasiPageState();
}

class _TambahMutasiPageState extends ConsumerState<TambahMutasiPage> {
  final _formKey = GlobalKey<FormState>();

  String? selectedJenisMutasi;
  int? selectedKeluargaId;

  int? rumahAsalId;
  int? rumahBaruId;

  final TextEditingController alasanController = TextEditingController();
  final TextEditingController tanggalController = TextEditingController();

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      tanggalController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final keluargaAsync = ref.watch(keluargaListProvider);
    final mutasiAsync = ref.watch(mutasiListProvider);

    final rumahAsalAsync = selectedKeluargaId == null
        ? null
        : ref.watch(rumahByKeluargaProvider(selectedKeluargaId!));

    final rumahSemuaAsync = ref.watch(rumahListProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Buat Mutasi Keluarga',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey[300], height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // ==========================
              // JENIS MUTASI
              // ==========================
              InputField(
                label: "Jenis Mutasi",
                hintText: "Pilih jenis mutasi",
                options: const ["pindah_rumah", "keluar_perumahan"],
                controller: TextEditingController(text: selectedJenisMutasi),
                onChanged: (v) {
                  setState(() => selectedJenisMutasi = v);
                },
                validator: (v) => v == null || v.isEmpty
                    ? "Jenis mutasi wajib dipilih"
                    : null,
              ),

              const SizedBox(height: 8),

              // ==========================
              // PILIH KELUARGA (FILTER)
              // ==========================
              mutasiAsync.when(
                data: (mutasiList) {
                  return keluargaAsync.when(
                    data: (keluargaList) {
                      // 🔥 Filter keluarga yang belum pernah dimutasi
                      final keluargaFiltered = keluargaList.where((kel) {
                        final mutasiKeluarga = mutasiList.where(
                          (m) => m.keluargaId == kel.keluargaId,
                        );

                        if (selectedJenisMutasi == "pindah_rumah") {
                          // keluarga yang pernah pindah_rumah boleh muncul lagi
                          return true;
                        }

                        if (selectedJenisMutasi == "keluar_perumahan") {
                          // keluarga yang sudah pernah mutasi sama sekali → sembunyikan
                          return mutasiKeluarga.isEmpty;
                        }

                        return true;
                      }).toList();

                      return InputField(
                        label: "Keluarga",
                        hintText: "Pilih keluarga",
                        options: keluargaFiltered
                            .map(
                              (kel) => (kel.keluarga?['nama_keluarga'] ?? "-")
                                  .toString(),
                            )
                            .toList(),
                        controller: TextEditingController(),
                        onChanged: (value) {
                          final selected = keluargaFiltered.firstWhere(
                            (kel) => kel.keluarga?['nama_keluarga'] == value,
                          );
                          setState(() {
                            selectedKeluargaId = selected.keluargaId;
                            rumahAsalId = null;
                            rumahBaruId = null;
                          });
                        },
                        validator: (v) => v == null || v.isEmpty
                            ? "Keluarga wajib dipilih"
                            : null,
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text("Error: $e"),
                  );
                },
                loading: () => const CircularProgressIndicator(),
                error: (e, _) => Text("Error load mutasi: $e"),
              ),

              const SizedBox(height: 8),

              // ==========================
              // RUMAH ASAL (AUTO)
              // ==========================
              if (rumahAsalAsync != null)
                rumahAsalAsync.when(
                  data: (rumahList) {
                    if (rumahList.isNotEmpty) {
                      rumahAsalId = rumahList.first.id;
                    }
                    return InputField(
                      label: "Rumah Asal",
                      hintText: "",
                      enabled: false,
                      readOnly: true,
                      controller: TextEditingController(
                        text: rumahList.isNotEmpty
                            ? "Blok ${rumahList.first.blok} - No. ${rumahList.first.nomorRumah}"
                            : "-",
                      ),
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text("Gagal memuat rumah: $e"),
                ),

              const SizedBox(height: 8),

              // ==========================
              // RUMAH BARU (FILTER RUMAH ASAL)
              // ==========================
              if (selectedJenisMutasi == "pindah_rumah")
                rumahSemuaAsync.when(
                  data: (rumahList) {
                    // 🔍 Filter rumah baru
                    final rumahBaruFiltered = rumahList.where((r) {
                      // ❌ Jangan tampilkan rumah asal (yang ditempati sekarang)
                      if (r.id == rumahAsalId) return false;

                      // ❌ Jangan tampilkan rumah yang ditempati keluarga lain
                      if (r.keluargaId != null &&
                          r.keluargaId != selectedKeluargaId) {
                        return false;
                      }

                      // ✔ Rumah kosong boleh
                      // ✔ Rumah yang pernah ditempati tapi sekarang kosong → boleh
                      // ✔ Rumah yang ditempati keluarga ini (kasus pindah balik) → boleh

                      return true;
                    }).toList();

                    // ⚠️ Jika tidak ada rumah tersedia
                    if (rumahBaruFiltered.isEmpty) {
                      return InputField(
                        label: "Rumah Baru",
                        hintText: "Tidak ada rumah tersedia",
                        enabled: false,
                        readOnly: true,
                        controller: TextEditingController(text: "-"),
                      );
                    }

                    // ✔ Normal dropdown
                    return InputField(
                      label: "Rumah Baru",
                      hintText: "Pilih rumah baru",
                      optionsKV: rumahBaruFiltered
                          .map(
                            (r) => {
                              "value": r.id,
                              "label": "Blok ${r.blok} - No. ${r.nomorRumah}",
                            },
                          )
                          .toList(),
                      initialValueKV: rumahBaruId,
                      onChangedKV: (id) => setState(() => rumahBaruId = id),
                      validator: (v) =>
                          v == null ? "Rumah baru wajib dipilih" : null,
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (e, _) => Text("Error load rumah: $e"),
                ),

              const SizedBox(height: 8),

              InputField(
                label: "Alasan Mutasi",
                hintText: "Masukkan alasan",
                controller: alasanController,
                validator: (v) =>
                    v == null || v.isEmpty ? "Alasan wajib diisi" : null,
              ),

              const SizedBox(height: 8),

              GestureDetector(
                onTap: _selectDate,
                child: AbsorbPointer(
                  child: InputField(
                    label: "Tanggal Mutasi",
                    hintText: "yyyy-mm-dd",
                    controller: tanggalController,
                    validator: (v) =>
                        v == null || v.isEmpty ? "Tanggal wajib diisi" : null,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // ==========================
              // SIMPAN
              // ==========================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final mutasi = MutasiModel(
                      id: 0,
                      keluargaId: selectedKeluargaId!,
                      jenisMutasi: selectedJenisMutasi!,
                      alasanMutasi: alasanController.text.trim(),
                      tanggalMutasi: DateTime.tryParse(
                        tanggalController.text.trim(),
                      ),
                      rumahId: rumahAsalId,
                      rumahSekarangId: rumahBaruId,
                      createdAt: DateTime.now(),
                    );

                    try {
                      await ref.read(createMutasiProvider)(mutasi);

                      await ref.read(updateKeluargaRumahProvider)(
                        selectedKeluargaId!,
                        selectedJenisMutasi == "keluar_perumahan"
                            ? null
                            : rumahBaruId,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Mutasi berhasil disimpan"),
                        ),
                      );
                      ref.invalidate(keluargaListProvider);
                      ref.invalidate(rumahListProvider);
                      ref.invalidate(mutasiListProvider);
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal menyimpan mutasi: $e")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF6750A4),
                  ),
                  child: const Text(
                    "Simpan",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
