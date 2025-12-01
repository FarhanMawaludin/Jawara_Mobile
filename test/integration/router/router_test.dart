import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:jawaramobile/features/auth/presentations/pages/login_page.dart';
import 'package:jawaramobile/features/dashboard/presentations/pages/home_page.dart';
import 'package:jawaramobile/features/register/presentations/pages/register_step1_account.dart';
import 'package:jawaramobile/router/router.dart'; // <-- ini file router.dart kamu

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Wrapper untuk menjalankan router
 Widget createRouterApp(GoRouter router) {
  return ProviderScope(
    child: MaterialApp.router(
      routerConfig: router,
    ),
  );
}

  testWidgets("Router navigasi ke onboarding page", (tester) async {
    await tester.pumpWidget(createRouterApp(router));
    await tester.pumpAndSettle();

    expect(find.text("Jawara Pintar"), findsOneWidget);  // sesuaikan dengan text OnboardingPage
  });

  testWidgets("Router navigasi ke login page", (tester) async {
    await tester.pumpWidget(createRouterApp(router));
    await tester.pumpAndSettle();

    router.go("/login");
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
  });

  testWidgets("Router navigasi ke register step 1", (tester) async {
    await tester.pumpWidget(createRouterApp(router));
    await tester.pumpAndSettle();

    router.go("/register/step1");
    await tester.pumpAndSettle();

    expect(find.byType(RegisterStep1Account), findsOneWidget);
  });

  testWidgets("Router navigasi page di dalam ShellRoute", (tester) async {
    await tester.pumpWidget(createRouterApp(router));
    await tester.pumpAndSettle();

    router.go("/homepage");
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
  });
}
