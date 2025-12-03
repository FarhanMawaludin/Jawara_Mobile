import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';

void main() {
  testWidgets('AspirationDetailPage displays title, sender, relative time and message', (tester) async {
    final now = DateTime.now();
    final item = AspirationItem(
      sender: 'user@example.com',
      title: 'Judul Aspirasi',
      status: 'pending',
      date: now.subtract(const Duration(seconds: 10)),
      message: 'Isi aspirasi lengkap di sini',
    );

    await tester.pumpWidget(
      MaterialApp(home: AspirationDetailPage(item: item)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Judul Aspirasi'), findsOneWidget);
    expect(find.text('user@example.com'), findsOneWidget);
    // Recent timestamp should render as 'baru saja'
    expect(find.textContaining('baru saja'), findsOneWidget);
    expect(find.textContaining('Isi aspirasi lengkap di sini'), findsOneWidget);
  });
}
