import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';

void main() {
  test('formatDate returns Indonesian month names', () {
    final d = DateTime(2025, 11, 22);
    expect(formatDate(d), '22 November 2025');
  });

  test('statusColor and statusTextColor map values correctly', () {
    expect(statusColor('diterima'), isA<Color>());
    expect(statusTextColor('diterima'), isA<Color>());

    expect(statusColor('pending'), isA<Color>());
    expect(statusTextColor('pending'), isA<Color>());

    expect(statusColor('ditolak'), isA<Color>());
    expect(statusTextColor('ditolak'), isA<Color>());

    expect(statusColor('unknown'), isA<Color>());
    expect(statusTextColor('unknown'), isA<Color>());
  });
}
