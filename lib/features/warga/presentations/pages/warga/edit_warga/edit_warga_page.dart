import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';

import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';

class EditWargaPage extends ConsumerStatefulWidget {
  final int wargaId;

  const EditWargaPage({super.key, required this.wargaId});

  @override
  ConsumerState<EditWargaPage> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends ConsumerState<EditWargaPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();

  // CONTROLLERS FOR DROPDOWNS (dipakai InputField)
  final TextEditingController jkController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();
  final TextEditingController goldarController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  int keluargaId = 0;
  DateTime? selectedTanggal;

  final jenisKelaminOptions = ["Laki-Laki", "Perempuan"];
  final roleOptions = ["Kepala Keluarga", "Ibu Rumah Tangga", "Anak"];
  final agamaOptions = ["Islam", "Kristen", "Katolik", "Hindu", "Buddha", "Konghucu"];
  final pendidikanOptions = [
    "SD", "SMP", "SMA", "SMK", "D1","D2","D3","D4","S1","S2","S3"
  ];
  final golDarahOptions = ["A", "B", "AB", "O"];
  final statusOptions = ["aktif", "tidak aktif"];

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final data = await ref.read(getWargaByIdUseCaseProvider)(widget.wargaId);

      if (data != null) {
        keluargaId = data.keluargaId;

        namaController.text = data.nama ?? "";
        nikController.text = data.nik ?? "";
        noTelpController.text = data.noTelp.toString();
        tempatLahirController.text = data.tempatLahir ?? "";
        pekerjaanController.text = data.pekerjaan ?? "";

        // ================================
        // NORMALISASI VALUE SESUAI DROPDOWN
        // ================================

        // 1. Jenis Kelamin
        jkController.text =
            (data.jenisKelamin?.toUpperCase() == "L") ? "Laki-Laki" : "Perempuan";

        // 2. Role Keluarga
        switch (data.roleKeluarga) {
          case "kepala_keluarga":
            roleController.text = "Kepala Keluarga";
            break;
          case "ibu_rumah_tangga":
            roleController.text = "Ibu Rumah Tangga";
            break;
          case "anak":
            roleController.text = "Anak";
            break;
          default:
            roleController.text = "";
        }

        // 3. Agama (API huruf kecil → UI Title Case)
        agamaController.text = (data.agama != null)
            ? data.agama![0].toUpperCase() +
                data.agama!.substring(1).toLowerCase()
            : "";

        // 4. Dropdown lainnya (sudah sama format dengan API)
        pendidikanController.text = data.pendidikan ?? "";
        goldarController.text = data.golonganDarah.toString();
        statusController.text = data.status.toString();

        // 5. Tanggal Lahir
        if (data.tanggalLahir != null) {
          selectedTanggal = data.tanggalLahir!;
          tanggalLahirController.text =
              "${selectedTanggal!.year}-${selectedTanggal!.month.toString().padLeft(2, '0')}-${selectedTanggal!.day.toString().padLeft(2, '0')}";
        }

        setState(() {});
      }
    });
  }

  // ===========================
  // KONVERSI UI KE FORMAT DB
  // ===========================

  String? _jkToDB(String? v) {
    if (v == "Laki-Laki") return "L";
    if (v == "Perempuan") return "P";
    return null;
  }

  String? _roleToDB(String? v) {
    if (v == "Kepala Keluarga") return "kepala_keluarga";
    if (v == "Ibu Rumah Tangga") return "ibu_rumah_tangga";
    if (v == "Anak") return "anak";
    return v;
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedTanggal ?? DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      selectedTanggal = picked;

      tanggalLahirController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateWarga = ref.read(updateWargaUseCaseProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Warga",
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
              
              InputField(label: "Nama", hintText: "Masukkan nama", controller: namaController),
              InputField(label: "NIK", hintText: "Masukkan NIK", controller: nikController),
              InputField(label: "No Telepon", hintText: "08xxxxx", controller: noTelpController),
              InputField(label: "Tempat Lahir", hintText: "Masukkan tempat lahir", controller: tempatLahirController),

              InkWell(
                onTap: _pickDate,
                child: IgnorePointer(
                  child: InputField(
                    label: "Tanggal Lahir",
                    hintText: "Pilih tanggal",
                    controller: tanggalLahirController,
                  ),
                ),
              ),

              // DROPDOWNS
              InputField(
                label: "Jenis Kelamin",
                hintText: "Pilih jenis kelamin",
                controller: jkController,
                options: jenisKelaminOptions,
                onChanged: (v) => setState(() => jkController.text = v),
              ),

              InputField(
                label: "Golongan Darah",
                hintText: "Pilih golongan darah",
                controller: goldarController,
                options: golDarahOptions,
                onChanged: (v) => setState(() => goldarController.text = v),
              ),

              InputField(
                label: "Role Keluarga",
                hintText: "Pilih peran",
                controller: roleController,
                options: roleOptions,
                onChanged: (v) => setState(() => roleController.text = v),
              ),

              InputField(
                label: "Agama",
                hintText: "Pilih agama",
                controller: agamaController,
                options: agamaOptions,
                onChanged: (v) => setState(() => agamaController.text = v),
              ),

              InputField(
                label: "Pendidikan",
                hintText: "Pilih pendidikan",
                controller: pendidikanController,
                options: pendidikanOptions,
                onChanged: (v) => setState(() => pendidikanController.text = v),
              ),

              InputField(
                label: "Pekerjaan",
                hintText: "Masukkan pekerjaan",
                controller: pekerjaanController,
              ),

              InputField(
                label: "Status",
                hintText: "Pilih status",
                controller: statusController,
                options: statusOptions,
                onChanged: (v) => setState(() => statusController.text = v),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final warga = Warga(
                      id: widget.wargaId,
                      keluargaId: keluargaId,

                      nama: namaController.text.trim(),
                      nik: nikController.text.trim(),
                      noTelp: noTelpController.text.trim(),
                      tempatLahir: tempatLahirController.text.trim(),

                      jenisKelamin: _jkToDB(jkController.text),
                      roleKeluarga: _roleToDB(roleController.text),

                      agama: agamaController.text.toLowerCase(),
                      golonganDarah: goldarController.text,
                      pendidikan: pendidikanController.text,
                      pekerjaan: pekerjaanController.text.trim(),
                      status: statusController.text,

                      tanggalLahir: selectedTanggal,
                      createdAt: DateTime.now(),
                    );

                    await updateWarga(warga);

                    showBottomAlert(
                      context: context,
                      title: "Berhasil Diperbarui",
                      message: "Data warga telah diperbarui.",
                      yesText: "Kembali",
                      onlyYes: true,
                      onYes: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      icon: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.22,
                        child: Lottie.asset("assets/lottie/Done.json"),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Simpan Perubahan",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
