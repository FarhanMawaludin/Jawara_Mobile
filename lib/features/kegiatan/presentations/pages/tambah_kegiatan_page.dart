import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/kegiatan_form_provider.dart';

class TambahKegiatanPage extends ConsumerStatefulWidget {
  const TambahKegiatanPage({super.key});

  @override
  ConsumerState<TambahKegiatanPage> createState() => _TambahKegiatanPageState();
}

class _TambahKegiatanPageState extends ConsumerState<TambahKegiatanPage> {
  final _formKey = GlobalKey<FormState>();
  final Color _primaryColor = const Color(0xFF6C63FF);

  final List<String> _kategoriList = [
    'Komunitas',
    'Kebersihan',
    'Kesehatan',
    'Keagamaan',
    'Pendidikan',
    'Olahraga',
    'Keamanan',
    'Sosial',
  ];

  String? _getDisplayKategori(String kategori) {
    if (kategori.isEmpty) return null;

    final match = _kategoriList.firstWhere(
      (k) => k.toLowerCase() == kategori.toLowerCase(),
      orElse: () => '',
    );

    return match.isEmpty ? null : match;
  }

  InputDecoration _inputDecoration({
    required String label,
    String? hint,
    IconData? icon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon:
          icon != null ? Icon(icon, color: Colors.grey[600], size: 20) : null,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      floatingLabelStyle: TextStyle(color: _primaryColor),
    );
  }

  // Konfirmasi saat keluar dari halaman
  Future<bool> _onWillPop() async {
    final formState = ref.read(kegiatanFormProvider);

    if (formState.isEmpty) {
      return true;
    }

    final shouldPop = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Batalkan?'),
        content: const Text(
          'Data yang Anda isi belum disimpan. Apakah Anda yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Lanjut Mengisi',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              ref.read(kegiatanFormProvider.notifier).reset();
              Navigator.pop(context, true);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );

    return shouldPop ?? false;
  }

  // Pilih tanggal kegiatan
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref
          .read(kegiatanFormProvider.notifier)
          .updateTanggalKegiatan(picked);
    }
  }

  // Submit form tambah kegiatan
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      final result =
          await ref.read(kegiatanFormProvider.notifier).submitForm();

      if (mounted) Navigator.pop(context);

      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Kegiatan berhasil ditambahkan'),
            backgroundColor: _primaryColor,
            behavior: SnackBarBehavior.floating,
          ),
        );

        if (mounted) Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Gagal menyimpan kegiatan',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(kegiatanFormProvider);

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            'Tambah Kegiatan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () async {
              final shouldPop = await _onWillPop();
              if (shouldPop && context.mounted) {
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama kegiatan
                  TextFormField(
                    initialValue: formState.namaKegiatan,
                    decoration: _inputDecoration(
                      label: 'Nama Kegiatan',
                      hint: 'Contoh: Kerja Bakti RT 01',
                      icon: Icons.event_note,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                    onChanged: (value) {
                      ref
                          .read(kegiatanFormProvider.notifier)
                          .updateNamaKegiatan(value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Tanggal kegiatan
                  InkWell(
                    onTap: () => _selectDate(context),
                    borderRadius: BorderRadius.circular(12),
                    child: InputDecorator(
                      decoration: _inputDecoration(
                        label: 'Tanggal Pelaksanaan',
                        icon: Icons.calendar_today_outlined,
                      ),
                      child: Text(
                        formState.tanggalKegiatan != null
                            ? DateFormat('dd MMMM yyyy')
                                .format(formState.tanggalKegiatan!)
                            : 'Pilih Tanggal',
                        style: TextStyle(
                          color: formState.tanggalKegiatan != null
                              ? Colors.black87
                              : Colors.grey[600],
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Lokasi kegiatan
                  TextFormField(
                    initialValue: formState.lokasi,
                    decoration: _inputDecoration(
                      label: 'Lokasi',
                      hint: 'Contoh: Lapangan Balai Warga',
                      icon: Icons.location_on_outlined,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                    onChanged: (value) {
                      ref
                          .read(kegiatanFormProvider.notifier)
                          .updateLokasi(value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Penanggung jawab
                  TextFormField(
                    initialValue: formState.penanggungJawab,
                    decoration: _inputDecoration(
                      label: 'Penanggung Jawab',
                      hint: 'Nama Ketua Panitia',
                      icon: Icons.person_outline,
                    ),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                    onChanged: (value) {
                      ref
                          .read(kegiatanFormProvider.notifier)
                          .updatePenanggungJawab(value);
                    },
                  ),
                  const SizedBox(height: 20),

                  // Kategori kegiatan
                  DropdownButtonFormField<String>(
                    value: _getDisplayKategori(formState.kategori),
                    decoration: _inputDecoration(
                      label: 'Kategori',
                      icon: Icons.category_outlined,
                    ),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    items: _kategoriList.map((String kategori) {
                      return DropdownMenuItem<String>(
                        value: kategori,
                        child: Text(kategori),
                      );
                    }).toList(),
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Wajib dipilih' : null,
                    onChanged: (value) {
                      if (value != null) {
                        ref
                            .read(kegiatanFormProvider.notifier)
                            .updateKategori(value.toLowerCase());
                      }
                    },
                  ),
                  const SizedBox(height: 20),

                  // Deskripsi kegiatan
                  TextFormField(
                    initialValue: formState.deskripsi,
                    decoration: _inputDecoration(
                      label: 'Deskripsi Lengkap',
                      hint: 'Jelaskan detail kegiatan...',
                    ).copyWith(
                      alignLabelWithHint: true,
                      contentPadding: const EdgeInsets.all(20),
                    ),
                    maxLines: 5,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? 'Wajib diisi' : null,
                    onChanged: (value) {
                      ref
                          .read(kegiatanFormProvider.notifier)
                          .updateDeskripsi(value);
                    },
                  ),
                  const SizedBox(height: 40),

                  // Tombol submit
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: _primaryColor.withOpacity(0.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Simpan Kegiatan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
