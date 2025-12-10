import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/core/component/bottom_alert.dart';
import 'package:lottie/lottie.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class EditWargaPage extends ConsumerStatefulWidget {
  final int wargaId;

  const EditWargaPage({super.key, required this.wargaId});

  @override
  ConsumerState<EditWargaPage> createState() => _EditWargaPageState();
}

class _EditWargaPageState extends ConsumerState<EditWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // TEXTFIELD CONTROLLERS
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nikController = TextEditingController();
  final TextEditingController noTelpController = TextEditingController();
  final TextEditingController tempatLahirController = TextEditingController();
  final TextEditingController tanggalLahirController = TextEditingController();
  final TextEditingController pekerjaanController = TextEditingController();

  // DROPDOWN CONTROLLERS
  final TextEditingController jkController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController agamaController = TextEditingController();
  final TextEditingController pendidikanController = TextEditingController();
  final TextEditingController goldarController = TextEditingController();
  final TextEditingController statusController = TextEditingController();

  int keluargaId = 0;
  DateTime? selectedTanggal;

  // Tambahan untuk update
  String? originalNik;
  DateTime? createdAtOld;

  // OPTIONS LIST
  final jenisKelaminOptions = ["Laki-Laki", "Perempuan"];
  final roleOptions = ["Kepala Keluarga", "Ibu Rumah Tangga", "Anak"];
  final agamaOptions = [
    "Islam",
    "Kristen",
    "Katolik",
    "Hindu",
    "Buddha",
    "Konghucu",
  ];
  final pendidikanOptions = [
    "SD",
    "SMP",
    "SMA",
    "SMK",
    "D1",
    "D2",
    "D3",
    "D4",
    "S1",
    "S2",
    "S3",
  ];
  final golDarahOptions = ["A", "B", "AB", "O"];
  final statusOptions = ["aktif", "tidak aktif"];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await ref.read(getWargaByIdUseCaseProvider)(widget.wargaId);

    if (data != null) {
      keluargaId = data.keluargaId;

      createdAtOld = data.createdAt;
      originalNik = data.nik;

      namaController.text = data.nama ?? "";
      nikController.text = data.nik ?? "";
      noTelpController.text = data.noTelp ?? "";
      tempatLahirController.text = data.tempatLahir ?? "";
      pekerjaanController.text = data.pekerjaan ?? "";

      // NORMALISASI NILAI DROPDOWN
      jkController.text = (data.jenisKelamin?.toUpperCase() == "L")
          ? "Laki-Laki"
          : "Perempuan";

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

      agamaController.text = (data.agama != null)
          ? data.agama![0].toUpperCase() +
                data.agama!.substring(1).toLowerCase()
          : "";

      pendidikanController.text = data.pendidikan ?? "";
      goldarController.text = data.golonganDarah ?? "";
      statusController.text = data.status ?? "";

      // TANGGAL LAHIR
      if (data.tanggalLahir != null) {
        selectedTanggal = data.tanggalLahir!;
        tanggalLahirController.text =
            "${selectedTanggal!.year}-${selectedTanggal!.month.toString().padLeft(2, '0')}-${selectedTanggal!.day.toString().padLeft(2, '0')}";
      }

      setState(() {});
    }
  }

  // KONVERSI KE FORMAT DB
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

  void _showError(String message) {
    showBottomAlert(
      context: context,
      title: "Validasi Gagal",
      message: message,
      onYes: () {
        Navigator.pop(context);
      },
      yesText: "OK",
      onlyYes: true,
      icon: SizedBox(
        height: MediaQuery.of(context).size.height * 0.22,
        child: Lottie.asset("assets/lottie/Failed.json"),
      ),
    );
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
          child: Container(height: 1, color: Colors.grey[300]),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              InputField(
                label: "Nama",
                hintText: "Masukkan nama",
                controller: namaController,
              ),
              InputField(
                label: "NIK",
                hintText: "Masukkan NIK",
                controller: nikController,
              ),
              InputField(
                label: "No Telepon",
                hintText: "08xxxxx",
                controller: noTelpController,
              ),
              InputField(
                label: "Tempat Lahir",
                hintText: "Masukkan tempat lahir",
                controller: tempatLahirController,
              ),

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

              InputField(
                label: "Jenis Kelamin",
                hintText: "Pilih jenis kelamin",
                controller: jkController,
                options: jenisKelaminOptions,
                onChanged: (v) => jkController.text = v,
              ),

              InputField(
                label: "Golongan Darah",
                hintText: "Pilih golongan darah",
                controller: goldarController,
                options: golDarahOptions,
                onChanged: (v) => goldarController.text = v,
              ),

              InputField(
                label: "Role Keluarga",
                hintText: "Pilih peran",
                controller: roleController,
                options: roleOptions,
                onChanged: (v) => roleController.text = v,
              ),

              InputField(
                label: "Agama",
                hintText: "Pilih agama",
                controller: agamaController,
                options: agamaOptions,
                onChanged: (v) => agamaController.text = v,
              ),

              InputField(
                label: "Pendidikan",
                hintText: "Pilih pendidikan",
                controller: pendidikanController,
                options: pendidikanOptions,
                onChanged: (v) => pendidikanController.text = v,
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
                onChanged: (v) => statusController.text = v,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // ============================
                    // VALIDASI MANUAL CHECK
                    // ============================

                    if (namaController.text.trim().isEmpty) {
                      _showError("Nama tidak boleh kosong");
                      return;
                    }

                    if (jkController.text.isEmpty) {
                      _showError("Jenis kelamin wajib dipilih");
                      return;
                    }


                    if (roleController.text.isEmpty) {
                      _showError("Role keluarga wajib dipilih");
                      return;
                    }

                    // ============================

                    final warga = Warga(
                      id: widget.wargaId,
                      keluargaId: keluargaId,
                      nama: namaController.text.trim(),

                      nik:
                          (nikController.text.trim().isEmpty &&
                              originalNik == null)
                          ? null
                          : nikController.text.trim(),

                      noTelp: noTelpController.text.trim(),
                      tempatLahir: tempatLahirController.text.trim(),
                      jenisKelamin: jkController.text.isEmpty
                          ? null
                          : _jkToDB(jkController.text),

                      roleKeluarga: roleController.text.isEmpty
                          ? null
                          : _roleToDB(roleController.text),

                      agama: agamaController.text.isEmpty
                          ? null
                          : agamaController.text.toLowerCase(),

                      golonganDarah: (goldarController.text.isEmpty)
                          ? null
                          : goldarController.text,

                      pendidikan: pendidikanController.text.isEmpty
                          ? null
                          : pendidikanController.text,
                      pekerjaan: pekerjaanController.text.trim(),
                      status: statusController.text.isEmpty
                          ? null
                          : statusController.text,

                      tanggalLahir: selectedTanggal,

                      createdAt: DateTime.now(), // FIX !!
                    );

                    try {
                      await updateWarga(warga);

                      // BUAT LOG ACTIVITY SETELAH BERHASIL UPDATE WARGA
                      await ref.read(logActivityNotifierProvider.notifier).createLogWithCurrentUser(
                        title: 'Mengubah data warga: ${namaController.text}',
                      );

                      showBottomAlert(
                        context: context,
                        title: "Berhasil Diperbarui",
                        message: "Data warga telah diperbarui.",
                        yesText: "Kembali",
                        onlyYes: true,
                        onYes: () {
                          Navigator.pop(context);
                          context.pop();
                        },
                        icon: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.22,
                          child: Lottie.asset("assets/lottie/Done.json"),
                        ),
                      );
                    } catch (e) {
                      _showError("Gagal update warga: $e");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Simpan Perubahan",
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
