import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:jawaramobile/main.dart' as app;
import 'utils.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("E2E - Login Berhasil", (tester) async {
    app.main();
    await tester.pumpAndSettle();

    // Isi Email & Password
    await tester.enterText(find.byKey(const Key("emailField")), "admin@gmail.com");
    await tester.enterText(find.byKey(const Key("passwordField")), "password");
    await tester.pumpAndSettle();

    // Tekan Login
    await tester.tap(find.byKey(const Key("loginButton")));
    await tester.pumpAndSettle();

    // Tunggu homepage
    await waitForWidget(tester, find.text("Homepage"));

    expect(find.text("Homepage"), findsOneWidget);
  });
}
