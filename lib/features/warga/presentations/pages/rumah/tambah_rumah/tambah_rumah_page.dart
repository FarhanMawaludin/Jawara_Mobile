import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';

import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class TambahRumahPage extends ConsumerStatefulWidget {
  const TambahRumahPage({super.key});

  @override
  ConsumerState<TambahRumahPage> createState() => _TambahRumahPageState();
}

class _TambahRumahPageState extends ConsumerState<TambahRumahPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController blokController = TextEditingController();
  final TextEditingController nomorRumahController = TextEditingController();
  final TextEditingController alamatLengkapController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final createRumah = ref.read(createRumahProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Rumah Baru',
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InputField(
                label: "Blok",
                hintText: "Contoh: A / B / C",
                controller: blokController,
              ),

              const SizedBox(height: 16),

              InputField(
                label: "Nomor Rumah",
                hintText: "Contoh: 12 / 20B",
                controller: nomorRumahController,
              ),

              const SizedBox(height: 16),

              InputField(
                label: "Alamat Lengkap",
                hintText: "Contoh: Jl. Kenanga No. 12",
                controller: alamatLengkapController,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final rumah = Rumah(
                        id: 0, 
                        blok: blokController.text.trim(),
                        nomorRumah: nomorRumahController.text.trim(),
                        alamatLengkap: alamatLengkapController.text.trim(),
                        createdAt: DateTime.now(),
                      );

                      await createRumah(rumah);

                      // BUAT LOG ACTIVITY
                      await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
                        title: 'Menambahkan rumah baru: Blok ${blokController.text} No. ${nomorRumahController.text}',
                      );

                      ref.invalidate(rumahListProvider);

                      // === bottom alert berhasil ===
                      showBottomAlert(
                        context: context,
                        title: "Rumah Berhasil Ditambahkan",
                        message: "Data rumah baru telah disimpan ke dalam sistem.",
                        yesText: "Kembali",
                        onlyYes: true,
                        onYes: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: Lottie.asset(
                            'assets/lottie/Done.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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
