import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';

import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';

class EditRumahPage extends ConsumerStatefulWidget {
  final int rumahId;

  const EditRumahPage({super.key, required this.rumahId});

  @override
  ConsumerState<EditRumahPage> createState() => _EditRumahPageState();
}

class _EditRumahPageState extends ConsumerState<EditRumahPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController blokController = TextEditingController();
  final TextEditingController nomorRumahController = TextEditingController();
  final TextEditingController alamatLengkapController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Ambil data rumah existing
    Future.microtask(() async {
      final data = await ref.read(getRumahByIdProvider)(widget.rumahId);
      if (data != null) {
        blokController.text = data.blok.toString();
        nomorRumahController.text = data.nomorRumah.toString();
        alamatLengkapController.text = data.alamatLengkap.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final updateRumah = ref.read(updateRumahProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Rumah',
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
                        id: widget.rumahId,
                        blok: blokController.text.trim(),
                        nomorRumah: nomorRumahController.text.trim(),
                        alamatLengkap: alamatLengkapController.text.trim(),
                        createdAt: DateTime.now(),
                      );

                      await updateRumah(rumah);

                      ref.invalidate(rumahListProvider);

                      showBottomAlert(
                        context: context,
                        title: "Berhasil Diperbarui",
                        message: "Data rumah telah berhasil diperbarui.",
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
                    'Simpan Perubahan',
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
