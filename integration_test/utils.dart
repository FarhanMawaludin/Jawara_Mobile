import 'package:flutter_test/flutter_test.dart';

/// Tunggu widget sampai muncul
Future<void> waitForWidget(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isNotEmpty) return;
  }

  throw Exception("Widget tidak ditemukan dalam batas waktu: $finder");
}
