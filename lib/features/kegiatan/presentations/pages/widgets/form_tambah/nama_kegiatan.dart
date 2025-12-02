import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/kegiatan_form_provider.dart';

class NamaKegiatanField extends ConsumerWidget {
  final Color primaryColor;

  const NamaKegiatanField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: 'Nama Kegiatan',
      hintText: 'Contoh: Kerja Bakti RT 01',
      prefixIcon: Icon(Icons.event_note, color: Colors.grey[600], size: 20),
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

    return TextFormField(
      initialValue: formState.namaKegiatan,
      decoration: _inputDecoration(),
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama kegiatan wajib diisi';
        }
        if (value.trim().length < 5) {
          return 'Nama kegiatan minimal 5 karakter';
        }
        return null;
      },
      onChanged: (value) {
        ref.read(kegiatanFormProvider.notifier).updateNamaKegiatan(value);
      },
    );
  }
}