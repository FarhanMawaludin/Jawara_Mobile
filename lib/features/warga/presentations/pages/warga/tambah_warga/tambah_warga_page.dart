// lib/features/warga/presentation/pages/warga/tambah_warga/tambah_warga_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/features/warga/presentations/providers/statistik/statistik_warga.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'package:jawaramobile/features/warga/presentations/providers/rumah/rumah_providers.dart'
    hide supabaseClientProvider;
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart'
    as rumah_entity;
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
  int? _selectedRumahId;

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
    'TK',
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
    'Lainnya',
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

    // jika keluarga tidak dipilih, izinkan null dan default role jadi Kepala Keluarga
    if (_selectedKeluargaId == null) {
      _selectedRoleKeluarga ??= 'Kepala Keluarga';
    }

    if (_selectedJenisKelamin == null) return _show("Pilih jenis kelamin");
    if (_selectedRoleKeluarga == null) return _show("Pilih peran keluarga");
    if (_selectedStatus == null) return _show("Pilih status");
    if (_tanggalLahir == null) return _show("Pilih tanggal lahir");
    if (_agama == null) return _show("Pilih agama");
    if (_pendidikan == null) return _show("Pilih pendidikan");

    _formKey.currentState!.save();

    final client = ref.read(supabaseClientProvider);

    // Jika keluarga tidak dipilih dan perannya Kepala Keluarga,
    // buat entri keluarga baru dan gunakan id-nya untuk warga.
    int? keluargaId = _selectedKeluargaId;
    if (keluargaId == null && _selectedRoleKeluarga == 'Kepala Keluarga') {
      try {
        // pastikan nama kepala keluarga tersedia sebelum membuat keluarga
        if (_nama.trim().isEmpty) {
          return _show('Nama harus diisi untuk membuat keluarga baru');
        }

        // gunakan nama kepala keluarga sebagai nama_keluarga (konsisten dengan flow register)
        final resp = await client.from('keluarga').insert({
          'nama_keluarga': _nama,
        }).select();

        if (resp is List && resp.isNotEmpty) {
          keluargaId = resp[0]['id'];
          // tambahkan ke list lokal agar UI konsisten jika perlu
          _keluargaList.add({'id': keluargaId, 'nama_keluarga': _nama});
        }
      } catch (e) {
        return _show('Gagal membuat keluarga baru: $e');
      }
    }

    final data = {
      'keluarga_id': keluargaId,
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
      'alamat_rumah_id': _selectedRumahId,
    };

    try {
      final client = ref.read(supabaseClientProvider);

      // jika user memilih rumah ketika menambah kepala keluarga baru,
      // update rumah.keluarga_id -> keluargaId sebelum menyimpan warga
      if (_selectedRumahId != null && keluargaId != null) {
        try {
          final rumahList = await ref.read(rumahListProvider.future);
          final rumah = rumahList.firstWhere((r) => r.id == _selectedRumahId);

          final updatedRumah = rumah_entity.Rumah(
            id: rumah.id,
            keluargaId: keluargaId,
            blok: rumah.blok,
            nomorRumah: rumah.nomorRumah,
            alamatLengkap: rumah.alamatLengkap,
            createdAt: rumah.createdAt,
          );

          final updateRumah = ref.read(updateRumahProvider);
          await updateRumah(updatedRumah);
        } catch (_) {
          // jika update rumah gagal, lanjutkan namun beri tahu user
          _show('Perhatian: gagal mengaitkan rumah ke keluarga');
        }
      }

      await client.from('warga').insert(data).select();

      // BUAT LOG ACTIVITY SETELAH BERHASIL MENAMBAH WARGA
      await ref
          .read(logActivityNotifierProvider.notifier)
          .createLogWithCurrentUser(title: 'Menambahkan warga baru: $_nama');

      ref.invalidate(wargaListProvider);
      ref.invalidate(keluargaListProvider);
      ref.invalidate(totalKeluargaProvider);
      ref.invalidate(totalWargaProvider);
      ref.invalidate(statistikWargaControllerProvider);

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
    // tambahkan opsi kosong di awal agar user bisa memilih "kosong"
    final keluargaNames =
        ['Tidak Ada'] +
        _keluargaList.map((e) => e['nama_keluarga'].toString()).toList();

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

                    // jika user memilih opsi kosong ('Tidak Ada'), set keluarga id jadi null
                    if (val == 'Tidak Ada') {
                      _selectedKeluargaId = null;
                      // jangan otomatis ubah role di sini -- handled saat simpan
                    } else {
                      final f = _keluargaList.firstWhere(
                        (m) => m['nama_keluarga'] == val,
                        orElse: () => {},
                      );
                      _selectedKeluargaId = f['id'];
                    }
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
                    // tampilkan tanggal dengan warna hitam ketika sudah dipilih
                    style: TextStyle(
                      color: const Color(0xFF1A1A1A),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: _tanggalLahir == null
                          ? "Pilih Tanggal Lahir"
                          : "${_tanggalLahir!.day}-${_tanggalLahir!.month}-${_tanggalLahir!.year}",
                      hintStyle: TextStyle(
                        color: _tanggalLahir == null
                            ? Colors.grey[400]
                            : const Color(0xFF1A1A1A),
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
                onChanged: (v) => setState(() => _selectedRoleKeluarga = v),
              ),

              // Jika role adalah Kepala Keluarga dan keluarga belum dipilih (null),
              // tampilkan dropdown pilihan alamat rumah dari provider rumahListProvider
              if (_selectedRoleKeluarga == 'Kepala Keluarga' &&
                  _selectedKeluargaId == null)
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Consumer(
                    builder: (context, ref, _) {
                      final rumahAsync = ref.watch(rumahListProvider);
                      return rumahAsync.when(
                        data: (rumahList) {
                          // hanya tampilkan rumah yang belum punya keluarga (keluargaId == null)
                          final available = rumahList
                              .where((r) => r.keluargaId == null)
                              .toList();

                          if (available.isEmpty) {
                            return const Text(
                              'Tidak ada alamat rumah tersedia',
                            );
                          }

                          final options = available
                              .map(
                                (r) => DropdownMenuItem<int>(
                                  value: r.id,
                                  child: Text(
                                    r.blok != null && r.nomorRumah != null
                                        ? '${r.blok} - ${r.nomorRumah}'
                                        : (r.alamatLengkap ?? 'Rumah #${r.id}'),
                                  ),
                                ),
                              )
                              .toList();

                          return DropdownButtonFormField<int>(
                            value: _selectedRumahId,
                            decoration: InputDecoration(
                              labelText: 'Pilih Alamat Rumah',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide(
                                  color: Colors.grey[400]!,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            items: options,
                            onChanged: (val) =>
                                setState(() => _selectedRumahId = val),
                            hint: const Text('Pilih alamat rumah'),
                          );
                        },
                        loading: () => const SizedBox(
                          height: 56,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (e, st) => Text('Gagal memuat alamat rumah'),
                      );
                    },
                  ),
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
