import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jawaramobile/features/pengaturan/presentation/pages/log_activity/log_activity.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

void main() {
  late MockSupabaseClient mockClient;
  late MockGoTrueClient mockAuth;
  late MockUser mockUser;

  setUp(() {
    mockClient = MockSupabaseClient();
    mockAuth = MockGoTrueClient();
    mockUser = MockUser();

    when(() => mockClient.auth).thenReturn(mockAuth);
    when(() => mockAuth.currentUser).thenReturn(mockUser);
    when(() => mockUser.id).thenReturn('test-user-id-123');
  });

  Widget buildTestWidget(Override override) {
    return ProviderScope(
      overrides: [
        override,
        supabaseClientProviderForLog.overrideWithValue(mockClient),
      ],
      child: const MaterialApp(home: LogActivityPage()),
    );
  }

  group('LogActivityPage', () {
    testWidgets('displays activities with correct grouping and labels',
        (tester) async {
      final now = DateTime.now();
      final activities = [
        LogActivityModel(
          id: 1,
          title: 'Menambahkan iuran baru: Harian',
          userId: 'test-user-id-123',
          createdAt: now.subtract(const Duration(hours: 2)),
        ),
        LogActivityModel(
          id: 2,
          title: 'Menambahkan iuran baru: Kerja Bakti',
          userId: 'other-user-id',
          createdAt: now.subtract(const Duration(days: 1)),
        ),
        LogActivityModel(
          id: 3,
          title: 'Mendownload laporan keuangan',
          userId: null,
          createdAt: now.subtract(const Duration(days: 2)),
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        logActivityListProvider.overrideWith((ref) => Future.value(activities)),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Menambahkan iuran baru: Harian'), findsOneWidget);
      expect(find.text('Menambahkan iuran baru: Kerja Bakti'), findsOneWidget);
      expect(find.text('Mendownload laporan keuangan'), findsOneWidget);
      expect(find.text('Hari ini'), findsOneWidget);
      expect(find.text('Kemarin'), findsOneWidget);
      expect(find.text('Anda'), findsOneWidget);
      expect(find.textContaining('User other-us'), findsOneWidget);
      expect(find.text('Sistem'), findsOneWidget);
    });

    testWidgets('search filters and clears correctly', (tester) async {
      final now = DateTime.now();
      final activities = [
        LogActivityModel(
          id: 1,
          title: 'Menambahkan iuran baru',
          userId: 'user-1',
          createdAt: now,
        ),
        LogActivityModel(
          id: 2,
          title: 'Mendownload laporan',
          userId: 'user-2',
          createdAt: now,
        ),
      ];

      await tester.pumpWidget(buildTestWidget(
        logActivityListProvider.overrideWith((ref) => Future.value(activities)),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Menambahkan iuran baru'), findsOneWidget);
      expect(find.text('Mendownload laporan'), findsOneWidget);

      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'iuran');
      await tester.pumpAndSettle();

      expect(find.text('Menambahkan iuran baru'), findsOneWidget);
      expect(find.text('Mendownload laporan'), findsNothing);
      expect(find.byIcon(Icons.close), findsOneWidget);

      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      final textField = tester.widget<TextField>(searchField);
      expect(textField.controller?.text, isEmpty);
      expect(find.text('Mendownload laporan'), findsOneWidget);
    });

    testWidgets('back button runs in loading state', (tester) async {
      final completer = Completer<List<LogActivityModel>>();

      await tester.pumpWidget(buildTestWidget(
        logActivityListProvider.overrideWith((ref) => completer.future),
      ));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();

      completer.complete([]);
    });

    testWidgets('back button runs in error state', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        logActivityListProvider.overrideWith(
          (ref) => Future.error(Exception('Test error')),
        ),
      ));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('Gagal memuat aktivitas'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();
    });
    testWidgets('back button pops on error state', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            logActivityListProvider.overrideWith(
              (ref) => Future.error(Exception('Test error')), // force error state
            ),
            supabaseClientProviderForLog.overrideWithValue(mockClient),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LogActivityPage()),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pump();
      await tester.pump();

      expect(find.textContaining('Gagal memuat aktivitas'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(find.text('Open'), findsOneWidget);
      expect(find.textContaining('Gagal memuat aktivitas'), findsNothing);
    });

    testWidgets('back button navigates correctly', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            logActivityListProvider.overrideWith((ref) => Future.value([])),
            supabaseClientProviderForLog.overrideWithValue(mockClient),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LogActivityPage()),
                  ),
                  child: const Text('Open'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Log Aktivitas'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();

      expect(find.text('Log Aktivitas'), findsNothing);
      expect(find.text('Open'), findsOneWidget);
    });
  });
}

