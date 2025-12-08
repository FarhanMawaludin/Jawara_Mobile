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

  testWidgets('LogActivityPage displays log activities correctly',
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

    final override = logActivityListProvider.overrideWith(
      (ref) => Future.value(activities),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: const MaterialApp(home: LogActivityPage()),
      ),
    );

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

  testWidgets('LogActivityPage search filters activities correctly',
      (tester) async {
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

    final override = logActivityListProvider.overrideWith(
      (ref) => Future.value(activities),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: const MaterialApp(home: LogActivityPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Menambahkan iuran baru'), findsOneWidget);
    expect(find.text('Mendownload laporan'), findsOneWidget);

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'iuran');
    await tester.pumpAndSettle();

    expect(find.text('Menambahkan iuran baru'), findsOneWidget);
    expect(find.text('Mendownload laporan'), findsNothing);
  });

  testWidgets('LogActivityPage shows loading state', (tester) async {
    final completer = Completer<List<LogActivityModel>>();
    final override = logActivityListProvider.overrideWith(
      (ref) => completer.future,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: const MaterialApp(home: LogActivityPage()),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
    
    completer.complete([]);
    await tester.pumpAndSettle();
  });

  testWidgets('LogActivityPage shows error state', (tester) async {
    final override = logActivityListProvider.overrideWith(
      (ref) => Future.error(Exception('Failed to load')),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: const MaterialApp(home: LogActivityPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.textContaining('Gagal memuat aktivitas'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
  });

  testWidgets('LogActivityPage shows empty state', (tester) async {
    final override = logActivityListProvider.overrideWith(
      (ref) => Future.value([]),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: const MaterialApp(home: LogActivityPage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tidak ada aktivitas.'), findsOneWidget);
  });

  testWidgets('LogActivityPage search can be cleared', (tester) async {
    final now = DateTime.now();
    final activities = [
      LogActivityModel(
        id: 1,
        title: 'Test Activity',
        userId: 'user-1',
        createdAt: now,
      ),
    ];

    final override = logActivityListProvider.overrideWith(
      (ref) => Future.value(activities),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: const MaterialApp(home: LogActivityPage()),
      ),
    );

    await tester.pumpAndSettle();

    final searchField = find.byType(TextField);
    await tester.enterText(searchField, 'test');
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    final textField = tester.widget<TextField>(searchField);
    expect(textField.controller?.text, isEmpty);
  });

  testWidgets('LogActivityPage back button works', (tester) async {
    final override = logActivityListProvider.overrideWith(
      (ref) => Future.value([]),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          override,
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const LogActivityPage(),
                    ),
                  );
                },
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
}
