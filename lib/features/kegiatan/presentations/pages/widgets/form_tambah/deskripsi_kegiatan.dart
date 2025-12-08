import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/kegiatan_form_provider.dart';

class DeskripsiKegiatanField extends ConsumerWidget {
  final Color primaryColor;

  const DeskripsiKegiatanField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: 'Deskripsi Lengkap',
      hintText: 'Jelaskan detail kegiatan...',
      alignLabelWithHint: true,
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.all(20),
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
      initialValue: formState.deskripsi,
      decoration: _inputDecoration(),
      maxLines: 5,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Deskripsi wajib diisi';
        }
        if (value.trim().length < 10) {
          return 'Deskripsi minimal 10 karakter';
        }
        return null;
      },
      onChanged: (value) {
        ref.read(kegiatanFormProvider.notifier).updateDeskripsi(value);
      },
    );
  }
}