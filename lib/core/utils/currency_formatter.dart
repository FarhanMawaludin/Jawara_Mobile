import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue. copyWith(text: '');
    }

    final number = int.tryParse(newValue. text.replaceAll(RegExp(r'[^0-9]'), ''));
    
    if (number == null) {
      return oldValue;
    }

    final newText = _formatter.format(number);

    return TextEditingValue(
      text: newText,
      selection:  TextSelection.collapsed(offset: newText.length),
    );
  }
}