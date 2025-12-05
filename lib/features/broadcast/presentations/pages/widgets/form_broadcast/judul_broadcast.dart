import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/broadcast_form_provider.dart';

class JudulBroadcastField extends ConsumerWidget {
  final Color primaryColor;

  const JudulBroadcastField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(broadcastFormProvider);

    return TextFormField(
      initialValue: formState.judul,
      decoration: InputDecoration(
        labelText: 'Judul Pengumuman',
        hintText: 'Contoh: Jadwal Ronda Baru',
        prefixIcon: Icon(Icons.campaign, color: Colors.grey[600], size: 20),
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
      ),
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Judul wajib diisi';
        }
        return null;
      },
      onChanged: (value) {
        ref.read(broadcastFormProvider.notifier).updateJudul(value);
      },
    );
  }
}