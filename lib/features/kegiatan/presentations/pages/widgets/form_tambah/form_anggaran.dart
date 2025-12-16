// lib/features/kegiatan/presentations/pages/widgets/form_tambah/anggaran_kegiatan.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AnggaranKegiatanField extends StatelessWidget {
  final double anggaran;
  final ValueChanged<double> onChanged;

  const AnggaranKegiatanField({
    super.key,
    required this.anggaran,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Anggaran Kegiatan',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: anggaran > 0 ? anggaran.toStringAsFixed(0) : '',
          decoration: InputDecoration(
            hintText: 'Masukkan anggaran (opsional)',
            prefixText: 'Rp ',
            suffixIcon: anggaran > 0
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => onChanged(0),
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey[50],
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            _CurrencyInputFormatter(),
          ],
          onChanged: (value) {
            final numValue = double.tryParse(
              value.replaceAll('.', '').replaceAll(',', ''),
            );
            onChanged(numValue ?? 0);
          },
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final numValue = double.tryParse(
                value.replaceAll('.', '').replaceAll(',', ''),
              );
              if (numValue == null || numValue < 0) {
                return 'Anggaran tidak valid';
              }
            }
            return null;
          },
        ),
        if (anggaran > 0) ...[
          const SizedBox(height: 4),
          Text(
            currencyFormatter.format(anggaran),
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet, 
                     size: 16, 
                     color: Colors.blue[700]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Anggaran akan otomatis tercatat sebagai pengeluaran',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    final number = int.tryParse(newValue.text.replaceAll('.', ''));
    if (number == null) {
      return oldValue;
    }

    final formatter = NumberFormat('#,###', 'id_ID');
    final newText = formatter.format(number).replaceAll(',', '.');

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}