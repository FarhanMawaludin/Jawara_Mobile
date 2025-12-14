// lib/features/warga/presentation/pages/warga/tambah_warga/tambah_warga_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class TambahWargaPage extends ConsumerStatefulWidget {
  const TambahWargaPage({super.key});

  @override
  ConsumerState<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends ConsumerState<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedKeluargaName;
  int? _selectedKeluargaId;

  String _nama = '';
  String? _nik;
  String? _noTelp;
  String? _tempatLahir;
  DateTime? _tanggalLahir;

  String? _selectedJenisKelamin;
  String? _selectedRoleKeluarga;
  String? _selectedStatus;
  String? _selectedGolonganDarah;

  String? _agama;
  String? _pendidikan;
  String? _pekerjaan;

  List<Map<String, dynamic>> _keluargaList = [];
  bool _loadingKeluarga = false;

  final List<String> _jenisKelaminOptions = ['Laki-Laki', 'Perempuan'];
  final List<String> _roleKeluargaOptions = [
    'Kepala Keluarga',
    'Ibu Rumah Tangga',
    'Anak',
  ];
  final List<String> _statusOptions = ['aktif', 'tidak aktif'];
  final List<String> _golDarahOptions = ['A', 'B', 'AB', 'O'];

  final List<String> _agamaOptions = [
    'Islam',
    'Kristen',
    'Katolik',
    'Hindu',
    'Buddha',
    'Konghucu',
  ];

  final List<String> _pendidikanOptions = [
    'SD',
    'SMP',
    'SMA',
    'SMK',
    'D1',
    'D2',
    'D3',
    'D4',
    'S1',
    'S2',
    'S3',
  ];

  @override
  void initState() {
    super.initState();
    _loadKeluarga();
  }

  Future<void> _loadKeluarga() async {
    setState(() => _loadingKeluarga = true);

    try {
      final client = ref.read(supabaseClientProvider);
      final resp = await client.from('keluarga').select('id, nama_keluarga');

      if (resp is List) {
        _keluargaList = resp
            .map((e) => Map<String, dynamic>.from(e as Map))
            .toList();
      }
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal memuat daftar keluarga")),
      );
    } finally {
      if (mounted) setState(() => _loadingKeluarga = false);
    }
  }

  String? _mapJenisKelaminToDb(String? d) {
    if (d == 'Laki-Laki') return 'L';
    if (d == 'Perempuan') return 'P';
    return d;
  }

  String? _mapRoleToDb(String? r) {
    switch (r) {
      case 'Kepala Keluarga':
        return 'kepala_keluarga';
      case 'Ibu Rumah Tangga':
        return 'ibu_rumah_tangga';
      case 'Anak':
        return 'anak';
      default:
        return r;
    }
  }

  String? _mapAgamaToDb(String? a) {
    if (a == null) return null;
    a = a.toLowerCase();
    if (a == "buddha") return "budha"; // mapping DB
    return a;
  }

  Future<void> _pickTanggalLahir() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(now.year - 20),
      firstDate: DateTime(1900),
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _tanggalLahir = picked);
    }
  }

  String? _formatDate(DateTime? d) {
    if (d == null) return null;
    return "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";
  }

  Future<void> _onSimpan() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedKeluargaId == null) return _show("Pilih keluarga");
    if (_selectedJenisKelamin == null) return _show("Pilih jenis kelamin");
    if (_selectedRoleKeluarga == null) return _show("Pilih peran keluarga");
    if (_selectedStatus == null) return _show("Pilih status");
    if (_tanggalLahir == null) return _show("Pilih tanggal lahir");
    if (_agama == null) return _show("Pilih agama");
    if (_pendidikan == null) return _show("Pilih pendidikan");

    _formKey.currentState!.save();

    final data = {
      'keluarga_id': _selectedKeluargaId,
      'nama': _nama,
      'nik': _nik,
      'jenis_kelamin': _mapJenisKelaminToDb(_selectedJenisKelamin),
      'tanggal_lahir': _formatDate(_tanggalLahir),
      'role_keluarga': _mapRoleToDb(_selectedRoleKeluarga),
      'status': _selectedStatus,
      'golongan_darah': _selectedGolonganDarah,
      'no_telp': _noTelp,
      'tempat_lahir': _tempatLahir,
      'agama': _agama,
      'pendidikan': _pendidikan,
      'pekerjaan': _pekerjaan,
      'user_id': null,
      'alamat_rumah_id': null,
    };

    try {
      final client = ref.read(supabaseClientProvider);
      await client.from('warga').insert(data).select();

      // BUAT LOG ACTIVITY SETELAH BERHASIL MENAMBAH WARGA
      await ref
          .read(logActivityNotifierProvider.notifier)
          .createLogWithCurrentUser(title: 'Menambahkan warga baru: $_nama');

      ref.invalidate(wargaListProvider);
      ref.invalidate(keluargaListProvider);
      ref.invalidate(totalKeluargaProvider);
      ref.invalidate(totalWargaProvider);

      if (mounted) {
        _show("Data warga berhasil disimpan");
        Navigator.pop(context, true);
      }
    } catch (e) {
      _show("Gagal menyimpan: $e");
    }
  }

  void _show(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    final keluargaNames = _keluargaList
        .map((e) => e['nama_keluarga'].toString())
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Tambah Warga",
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
              InputField(
                label: "Pilih Keluarga",
                hintText: "Pilih Keluarga",
                options: keluargaNames,
                onChanged: (val) {
                  setState(() {
                    _selectedKeluargaName = val;
                    final f = _keluargaList.firstWhere(
                      (m) => m['nama_keluarga'] == val,
                      orElse: () => {},
                    );
                    _selectedKeluargaId = f['id'];
                  });
                },
              ),

              InputField(
                label: "Nama",
                hintText: "Masukkan Nama Lengkap",
                onChanged: (v) => _nama = v,
              ),

              InputField(
                label: "NIK",
                hintText: "Masukkan NIK",
                onChanged: (v) => _nik = v,
              ),

              InputField(
                label: "No. Telepon",
                hintText: "08xxxxxxxxxx",
                onChanged: (v) => _noTelp = v,
              ),

              InputField(
                label: "Tempat Lahir",
                hintText: "Masukkan tempat lahir",
                onChanged: (v) => _tempatLahir = v,
              ),

              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Tanggal Lahir",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color(0xFF1A1A1A),
                  ),
                ),
              ),
              const SizedBox(height: 6),

              InkWell(
                onTap: _pickTanggalLahir,
                child: IgnorePointer(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: _tanggalLahir == null
                          ? "Pilih Tanggal Lahir"
                          : "${_tanggalLahir!.day}-${_tanggalLahir!.month}-${_tanggalLahir!.year}",
                      hintStyle: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: Colors.deepPurpleAccent,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 16,
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (_) =>
                        _tanggalLahir == null ? "Tanggal lahir wajib" : null,
                  ),
                ),
              ),

              InputField(
                label: "Golongan Darah",
                hintText: "Pilih golongan darah",
                options: _golDarahOptions,
                onChanged: (v) => _selectedGolonganDarah = v,
              ),

              InputField(
                label: "Peran Keluarga",
                hintText: "Pilih peran keluarga",
                options: _roleKeluargaOptions,
                onChanged: (v) => _selectedRoleKeluarga = v,
              ),

              InputField(
                label: "Agama",
                hintText: "Pilih agama",
                options: _agamaOptions,
                onChanged: (v) {
                  setState(() {
                    _agama = _mapAgamaToDb(v);
                  });
                },
              ),

              InputField(
                label: "Pendidikan",
                hintText: "Pilih pendidikan",
                options: _pendidikanOptions,
                onChanged: (v) => _pendidikan = v,
              ),

              InputField(
                label: "Pekerjaan",
                hintText: "Masukkan pekerjaan",
                onChanged: (v) => _pekerjaan = v,
              ),

              InputField(
                label: "Status",
                hintText: "Pilih status",
                options: _statusOptions,
                onChanged: (v) => _selectedStatus = v,
              ),

              InputField(
                label: "Jenis Kelamin",
                hintText: "Pilih jenis kelamin",
                options: _jenisKelaminOptions,
                onChanged: (v) => _selectedJenisKelamin = v,
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent[400],
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _onSimpan,
                  child: const Text(
                    "Simpan",
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
