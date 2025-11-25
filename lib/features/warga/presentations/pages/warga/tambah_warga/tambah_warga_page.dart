// lib/features/warga/presentation/pages/warga/tambah_warga/tambah_warga_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/component/InputField.dart';
import 'package:jawaramobile/features/warga/presentations/providers/warga/warga_providers.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';

class TambahWargaPage extends ConsumerStatefulWidget {
  const TambahWargaPage({super.key});

  @override
  ConsumerState<TambahWargaPage> createState() => _TambahWargaPageState();
}

class _TambahWargaPageState extends ConsumerState<TambahWargaPage> {
  final _formKey = GlobalKey<FormState>();

  // Field state
  String? _selectedKeluargaName; 
  int? _selectedKeluargaId; // id yang akan dikirim ke DB
  String _nama = '';
  String? _nik;
  String? _noTelp;
  String? _tempatLahir;

  // new dropdown selections (display values)
  String? _selectedJenisKelamin; // display like "Laki-Laki"
  String? _selectedRoleKeluarga; // display like "Kepala Keluarga"
  String? _selectedStatus; // "aktif" or "tidak aktif"
  String? _selectedGolonganDarah; // "A","B","AB","O"

  String? _pendidikan;
  String? _pekerjaan;

  DateTime? _tanggalLahir;

  // local keluarga list 
  List<Map<String, dynamic>> _keluargaList = [];
  bool _loadingKeluarga = false;

  // nilai dropdown options
  final List<String> _jenisKelaminOptions = ['Laki-Laki', 'Perempuan'];
  final List<String> _roleKeluargaOptions = [
    'Kepala Keluarga',
    'Ibu Rumah Tangga',
    'Anak'
  ];
  final List<String> _statusOptions = ['aktif', 'tidak aktif'];
  final List<String> _golDarahOptions = ['A', 'B', 'AB', 'O'];

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
      // resp biasanya List<dynamic>
      _keluargaList = resp
          .where((e) => e is Map)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
        } catch (e) {
      // silent fail + beri pesan singkat
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat daftar keluarga: $e')),
        );
      }
      _keluargaList = [];
    } finally {
      if (mounted) setState(() => _loadingKeluarga = false);
    }
  }

  // mapping display -> db value
  String? _mapJenisKelaminToDb(String? display) {
    if (display == null) return null;
    if (display == 'Laki-Laki') return 'L';
    if (display == 'Perempuan') return 'P';
    return display;
  }

  String? _mapRoleKeluargaToDb(String? display) {
    if (display == null) return null;
    switch (display) {
      case 'Kepala Keluarga':
        return 'kepala_keluarga';
      case 'Ibu Rumah Tangga':
        return 'ibu_rumah_tangga';
      case 'Anak':
        return 'anak';
      default:
        return display;
    }
  }

  // show date picker
  Future<void> _pickTanggalLahir() async {
    final now = DateTime.now();
    final first = DateTime(1900);
    final picked = await showDatePicker(
      context: context,
      initialDate: _tanggalLahir ?? DateTime(now.year - 20),
      firstDate: first,
      lastDate: now,
    );

    if (picked != null) {
      setState(() => _tanggalLahir = picked);
    }
  }

  // helper format yyyy-mm-dd
  String? _formatDateOnly(DateTime? d) {
    if (d == null) return null;
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
  }

  // Simpan: panggil langsung Supabase (tanpa mengirim `id`)
  Future<void> _onSimpan() async {
    // lakukan validasi form (FormFields + required dropdowns)
    if (!_formKey.currentState!.validate()) return;

    // additional validation for dropdowns
    if (_selectedKeluargaId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih keluarga terlebih dahulu')));
      return;
    }
    if (_selectedJenisKelamin == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih jenis kelamin')));
      return;
    }
    if (_selectedRoleKeluarga == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih peran keluarga')));
      return;
    }
    if (_selectedStatus == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih status')));
      return;
    }
    if (_tanggalLahir == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Pilih tanggal lahir')));
      return;
    }

    // simpan state form ke variabel
    _formKey.currentState!.save();

    // mapping ke DB values
    final jenisKelaminDb = _mapJenisKelaminToDb(_selectedJenisKelamin);
    final roleKeluargaDb = _mapRoleKeluargaToDb(_selectedRoleKeluarga);
    final statusDb = _selectedStatus; // 'aktif' or 'tidak aktif'
    final golDarahDb = _selectedGolonganDarah;

    // siapkan data untuk insert
    final Map<String, dynamic> insertData = {
      'keluarga_id': _selectedKeluargaId,
      'nama': _nama,
      'nik': _nik,
      'jenis_kelamin': jenisKelaminDb,
      'tanggal_lahir': _formatDateOnly(_tanggalLahir),
      'role_keluarga': roleKeluargaDb,
      'user_id': null,
      'alamat_rumah_id': null,
      'no_telp': _noTelp,
      'tempat_lahir': _tempatLahir,
      'agama': null,
      'golongan_darah': golDarahDb,
      'pekerjaan': _pekerjaan,
      'status': statusDb,
    };

    try {
      final client = ref.read(supabaseClientProvider);

      // lakukan insert — tidak mengirim id agar Supabase auto-generate
      // .select() supaya Supabase mengembalikan baris yang dimasukkan (opsional)
      await client.from('warga').insert(insertData).select();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Warga Disimpan')),
        );
        // kembali dan beri tahu parent kalau perlu refresh
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // build daftar nama keluarga (untuk InputField.options)
    final keluargaNames =
        _keluargaList.map((m) => (m['nama_keluarga'] ?? '').toString()).toList();

    // UI utama
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tambah Warga',
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
              // Dropdown Pilih Keluarga 
              InputField(
                label: 'Pilih Keluarga',
                hintText: _loadingKeluarga ? 'Memuat keluarga...' : 'Pilih Keluarga',
                options: keluargaNames,
                onChanged: (val) {
                  setState(() {
                    _selectedKeluargaName = val;
                    // cari id pada _keluargaList
                    final found = _keluargaList.firstWhere(
                      (m) => (m['nama_keluarga'] ?? '').toString() == val,
                      orElse: () => <String, dynamic>{},
                    );
                    if (found.isNotEmpty && found['id'] != null) {
                      final idRaw = found['id'];
                      _selectedKeluargaId = idRaw is int ? idRaw : int.tryParse(idRaw.toString());
                    } else {
                      _selectedKeluargaId = null;
                    }
                  });
                },
              ),

              // Input Nama
              InputField(
                label: "Nama",
                hintText: "Masukkan Nama Lengkap",
                onChanged: (val) => _nama = val,
              ),

              // NIK
              InputField(
                label: "Nik",
                hintText: "Masukkan NIK sesuai KTP",
                onChanged: (val) => _nik = val,
              ),

              // No. Telepon
              InputField(
                label: "No. Telepon",
                hintText: "08xxxxxxxxxx",
                onChanged: (val) => _noTelp = val,
              ),

              // Tempat Lahir
              InputField(
                label: "Tempat Lahir",
                hintText: "Masukkan tempat lahir",
                onChanged: (val) => _tempatLahir = val,
              ),

              // Tanggal Lahir 
              Container(
                margin: const EdgeInsets.only(top: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tanggal Lahir',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.grey[950],
                      ),
                    ),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickTanggalLahir,
                      child: IgnorePointer(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: _tanggalLahir != null
                                ? "${_tanggalLahir!.day.toString().padLeft(2,'0')}-${_tanggalLahir!.month.toString().padLeft(2,'0')}-${_tanggalLahir!.year}"
                                : "Pilih tanggal lahir",
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.grey[400]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(color: Colors.deepPurpleAccent[400]!),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                            suffixIcon: const Icon(Icons.calendar_today),
                          ),
                          validator: (value) {
                            if (_tanggalLahir == null) {
                              return 'Tanggal lahir tidak boleh kosong';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Golongan Darah (A, B, AB, O)
              InputField(
                label: "Golongan Darah",
                hintText: "Pilih golongan darah",
                options: _golDarahOptions,
                onChanged: (val) => setState(() => _selectedGolonganDarah = val),
              ),

              // Peran Keluarga 
              InputField(
                label: "Peran Keluarga",
                hintText: "Pilih peran keluarga",
                options: _roleKeluargaOptions,
                onChanged: (val) => setState(() => _selectedRoleKeluarga = val),
              ),

              // Pendidikan Terakhir 
              InputField(
                label: "Pendidikan Terakhir",
                hintText: "Masukkan pendidikan terakhir",
                onChanged: (val) => _pendidikan = val,
              ),

              // Pekerjaan
              InputField(
                label: "Pekerjaan",
                hintText: "Masukkan pekerjaan",
                onChanged: (val) => _pekerjaan = val,
              ),

              // Status ('aktif' or 'tidak aktif')
              InputField(
                label: "Status",
                hintText: "Pilih status",
                options: _statusOptions,
                onChanged: (val) => setState(() => _selectedStatus = val),
              ),

              // Jenis Kelamin (dropdown)
              InputField(
                label: "Jenis Kelamin",
                hintText: "Pilih jenis kelamin",
                options: _jenisKelaminOptions,
                onChanged: (val) => setState(() => _selectedJenisKelamin = val),
              ),

              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () async {
                    // validasi manual: pastikan nama minimal
                    if (_nama.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
                      return;
                    }
                    // jalankan validator form
                    if (!_formKey.currentState!.validate()) return;

                    await _onSimpan();
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