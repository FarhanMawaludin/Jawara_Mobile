import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawaramobile/features/pengaturan/presentation/pages/log_activity/log_activity.dart';
import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {
  final MockAuthClient _auth = MockAuthClient();
  @override
  GoTrueClient get auth => _auth;
}
class MockAuthClient extends Mock implements GoTrueClient {
  final MockUser _user = MockUser();
  @override
  User? get currentUser => _user;
}
class MockUser implements User {
  @override
  String get id => 'user-1';
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockSupabaseClient mockClient;
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));

  setUp(() {
    mockClient = MockSupabaseClient();
    supabaseClientFactoryForLog = () => mockClient;
  });

  Widget buildApp(List<LogActivityModel> activities) => UncontrolledProviderScope(
    container: ProviderContainer(overrides: [
      logActivityListProvider.overrideWith((ref) async => activities),
      supabaseClientProviderForLog.overrideWithValue(mockClient),
    ]),
    child: const MaterialApp(home: LogActivityPage()),
  );

  Widget buildNavApp(Widget Function(BuildContext) builder) => MaterialApp(
    home: Scaffold(body: Builder(builder: (ctx) => ElevatedButton(
      onPressed: () => Navigator.push(ctx, MaterialPageRoute(builder: builder)),
      child: const Text('Open')))));

  group('Widget Tests', () {
    testWidgets('loading state shows indicator', (tester) async {
      await tester.pumpWidget(UncontrolledProviderScope(
        container: ProviderContainer(overrides: [
          logActivityListProvider.overrideWith((ref) async {
            await Future.delayed(const Duration(seconds: 1));
            return [];
          }),
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ]),
        child: const MaterialApp(home: LogActivityPage())));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.pumpAndSettle();
    });

    testWidgets('error state shows message and back button works', (tester) async {
      await tester.pumpWidget(buildNavApp((_) => UncontrolledProviderScope(
        container: ProviderContainer(overrides: [
          logActivityListProvider.overrideWith((ref) async => throw Exception('Test error')),
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ]),
        child: const LogActivityPage())));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Gagal memuat aktivitas:'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(find.byType(LogActivityPage), findsNothing);
    });

    testWidgets('empty state shows message', (tester) async {
      await tester.pumpWidget(buildApp([]));
      await tester.pumpAndSettle();
      expect(find.text('Tidak ada aktivitas.'), findsOneWidget);
    });

    testWidgets('displays activities with grouping and labels', (tester) async {
      await tester.pumpWidget(buildApp([
        LogActivityModel(id: 1, title: 'Login', userId: 'user-1', createdAt: today),
        LogActivityModel(id: 2, title: 'Delete', userId: null, createdAt: yesterday),
      ]));
      await tester.pumpAndSettle();
      expect(find.text('Hari ini'), findsOneWidget);
      expect(find.text('Kemarin'), findsOneWidget);
      expect(find.text('Anda'), findsOneWidget);
      expect(find.text('Sistem'), findsOneWidget);
    });

    testWidgets('search filters and clears', (tester) async {
      await tester.pumpWidget(buildApp([
        LogActivityModel(id: 1, title: 'User login', userId: 'user-1', createdAt: today),
        LogActivityModel(id: 2, title: 'Data update', userId: 'user-2', createdAt: today),
      ]));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'LOGIN');
      await tester.pumpAndSettle();
      expect(find.text('User login'), findsOneWidget);
      expect(find.text('Data update'), findsNothing);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Data update'), findsOneWidget);
    });

    testWidgets('truncates long user ID', (tester) async {
      await tester.pumpWidget(buildApp([LogActivityModel(id: 1, title: 'T', userId: 'very-long-user-id', createdAt: today)]));
      await tester.pumpAndSettle();
      expect(find.text('User very-lon...'), findsOneWidget);
    });

    testWidgets('formats old dates', (tester) async {
      await tester.pumpWidget(buildApp([LogActivityModel(id: 1, title: 'O', userId: 'u', createdAt: DateTime(2024, 1, 15))]));
      await tester.pumpAndSettle();
      expect(find.text('15 Januari 2024'), findsOneWidget);
    });

    testWidgets('back button works in data state', (tester) async {
      await tester.pumpWidget(buildNavApp((_) => UncontrolledProviderScope(
        container: ProviderContainer(overrides: [
          logActivityListProvider.overrideWith((ref) async => [LogActivityModel(id: 1, title: 'T', userId: 'u', createdAt: today)]),
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ]),
        child: const LogActivityPage())));
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pumpAndSettle();
      expect(find.byType(LogActivityPage), findsNothing);
    });
  });

  group('Model Tests', () {
    test('fromMap parses all fields', () {
      final m = LogActivityModel.fromMap({'id': 1, 'title': 'T', 'user_id': 'u', 'created_at': '2024-01-01T00:00:00Z'});
      expect(m.id, 1);
      expect(m.title, 'T');
      expect(m.userId, 'u');
    });

    test('fromMap handles variations', () {
      expect(LogActivityModel.fromMap({'id': '1', 'title': 'T', 'created_at': '2024-01-01T00:00:00Z'}).id, 1);
      expect(LogActivityModel.fromMap({'id': 1, 'title': 'T', 'user_id': null, 'created_at': '2024-01-01T00:00:00Z'}).userId, null);
      expect(LogActivityModel.fromMap({'id': 1, 'title': 'T', 'userId': 'u', 'created_at': '2024-01-01T00:00:00Z'}).userId, 'u');
      expect(LogActivityModel.fromMap({'id': 1, 'created_at': '2024-01-01T00:00:00Z'}).title, '');
      expect(LogActivityModel.fromMap({'id': 1, 'title': 'T', 'createdAt': '2024-01-01T00:00:00Z'}).createdAt.year, 2024);
    });
  });
}
