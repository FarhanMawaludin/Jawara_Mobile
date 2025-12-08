import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/kegiatan_form_provider.dart';

class KategoriKegiatanDropdown extends ConsumerWidget {
  final Color primaryColor;

  const KategoriKegiatanDropdown({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  // List kategori untuk display (Title Case)
  static const List<String> _kategoriList = [
    'Komunitas',
    'Kebersihan',
    'Kesehatan',
    'Keagamaan',
    'Pendidikan',
    'Olahraga',
    'Keamanan',
    'Sosial',
  ];

  // Helper method untuk mendapatkan display value dari kategori
  String? _getDisplayKategori(String kategori) {
    if (kategori.isEmpty) return null;

    final match = _kategoriList.firstWhere(
      (k) => k.toLowerCase() == kategori.toLowerCase(),
      orElse: () => '',
    );

    return match.isEmpty ? null : match;
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: 'Kategori',
      prefixIcon: Icon(Icons.category_outlined, color: Colors.grey[600], size: 20),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
        borderSide: BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.red.shade400),
      ),
      floatingLabelStyle: TextStyle(color: primaryColor),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(kegiatanFormProvider);

    return DropdownButtonFormField<String>(
      value: _getDisplayKategori(formState.kategori),
      decoration: _inputDecoration(),
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      // Tambahan properti agar dropdown mengikuti style field
      isExpanded: true, 
      borderRadius: BorderRadius.circular(12), 
      dropdownColor: Colors.white, 
      elevation: 2, 
      menuMaxHeight: 300, 
      
      items: _kategoriList.map((String kategori) {
        return DropdownMenuItem<String>(
          value: kategori,
          child: Text(
            kategori,
            style: const TextStyle(
              fontSize: 14, 
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Kategori wajib dipilih';
        }
        return null;
      },
      onChanged: (value) {
        if (value != null) {
          // Simpan dalam lowercase ke state
          ref.read(kegiatanFormProvider.notifier).updateKategori(value.toLowerCase());
        }
      },
    );
  }
}