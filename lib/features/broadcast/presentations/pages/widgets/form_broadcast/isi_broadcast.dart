import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/broadcast_form_provider.dart';

class IsiBroadcastField extends ConsumerWidget {
  final Color primaryColor;

  const IsiBroadcastField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(broadcastFormProvider);

    return TextFormField(
      initialValue: formState.isi,
      decoration: InputDecoration(
        labelText: 'Isi Pengumuman',
        hintText: 'Tuliskan detail informasi...',
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
      ),
      maxLines: 6,
      textCapitalization: TextCapitalization.sentences,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Isi pengumuman wajib diisi';
        }
        if (value.length < 10) {
          return 'Isi pengumuman terlalu singkat';
        }
        return null;
      },
      onChanged: (value) {
        ref.read(broadcastFormProvider.notifier).updateIsi(value);
      },
    );
  }
}