import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawaramobile/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("E2E Login berhasil dengan server", (tester) async {
    // Jalankan aplikasi
    app.main();
    await tester.pumpAndSettle();

    // Masukkan email
    await tester.enterText(
      find.byKey(const Key("emailField")),
      "admin@gmail.com",
    );

    // Masukkan password
    await tester.enterText(
      find.byKey(const Key("passwordField")),
      "12345678",
    );

    await tester.pumpAndSettle();

    // Tekan tombol login
    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pumpAndSettle();

    // Tunggu respons API / animasi bottom_sheet
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Setelah login, halaman harus menuju homepage
    expect(find.text("Homepage"), findsOneWidget);
  });
}
