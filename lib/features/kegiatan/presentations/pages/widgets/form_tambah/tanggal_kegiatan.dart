import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../providers/kegiatan_form_provider.dart';

class TanggalKegiatanField extends ConsumerWidget {
  final Color primaryColor;

  const TanggalKegiatanField({
    super.key,
    this.primaryColor = const Color(0xFF6C63FF),
  });

  InputDecoration _inputDecoration() {
    return InputDecoration(
      labelText: 'Tanggal Pelaksanaan',
      prefixIcon: Icon(Icons.calendar_today_outlined, color: Colors.grey[600], size: 20),
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

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref.read(kegiatanFormProvider.notifier).updateTanggalKegiatan(picked);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(kegiatanFormProvider);

    return InkWell(
      onTap: () => _selectDate(context, ref),
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: _inputDecoration(),
        child: Text(
          formState.tanggalKegiatan != null
              ? DateFormat('dd MMMM yyyy').format(formState.tanggalKegiatan!)
              : 'Pilih Tanggal',
          style: TextStyle(
            color: formState.tanggalKegiatan != null
                ? Colors.black87
                : Colors.grey[600],
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}