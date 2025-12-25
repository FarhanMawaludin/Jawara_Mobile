import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockGoTrueClient extends Mock implements GoTrueClient {}

class MockUser extends Mock implements User {}

class FakeSelectOrderBuilder extends Fake
    implements
        PostgrestFilterBuilder<List<Map<String, dynamic>>>,
        PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> data;

  FakeSelectOrderBuilder({this.data = const []});

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> order(
    String column, {
    bool ascending = false,
    bool nullsFirst = false,
    String? referencedTable,
  }) {
    return this;
  }

  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>> value) onValue, {
    Function? onError,
  }) {
    return Future.sync(() => onValue(data));
  }
}

class FakeInsertBuilder extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>> value) onValue, {
    Function? onError,
  }) => Future.sync(() => onValue(const []));
}

void main() {
  late MockSupabaseClient defaultClient;

  ProviderContainer makeContainer(SupabaseClient client) => ProviderContainer(
    overrides: [supabaseClientProviderForLog.overrideWithValue(client)],
  );

  setUp(() {
    defaultClient = MockSupabaseClient();
    // Point factory to mock to avoid platform plugin calls.
    supabaseClientFactoryForLog = () => defaultClient;
  });

  tearDown(() {
    supabaseClientFactoryForLog = () => defaultClient;
  });

  group('LogActivityModel', () {
    test('parses common fields', () {
      final model = LogActivityModel.fromMap({
        'id': '1',
        'title': 'Title',
        'user_id': 'u1',
        'created_at': '2025-12-08T10:00:00Z',
      });

      expect(model.id, 1);
      expect(model.title, 'Title');
      expect(model.userId, 'u1');
    });

    test('supports alternative keys and defaults', () {
      final model = LogActivityModel.fromMap({
        'id': 2,
        'title': null,
        'userId': 'fallback',
        'createdAt': '2025-12-08T12:00:00Z',
      });

      expect(model.id, 2);
      expect(model.title, '');
      expect(model.userId, 'fallback');
      expect(model.createdAt.year, 2025);
    });
  });

  group('logActivityListProvider', () {
    test('fetches data via Supabase client', () async {
      final mockClient = MockSupabaseClient();
      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final fakeFilterBuilder = FakeSelectOrderBuilder(
        data: [
          {
            'id': 1,
            'title': 'Activity 1',
            'user_id': 'user-1',
            'created_at': '2025-12-08T10:00:00Z',
          },
        ],
      );

      when(
        () => mockClient.from('log_activity'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        () => mockQueryBuilder.select(any()),
      ).thenAnswer((_) => fakeFilterBuilder);

      final container = makeContainer(mockClient);

      final result = await container.read(logActivityListProvider.future);

      expect(result.single.title, 'Activity 1');
      verify(() => mockClient.from('log_activity')).called(1);
      verify(() => mockQueryBuilder.select('*')).called(1);

      container.dispose();
    });

    test('throws exception when Supabase call fails', () async {
      final mockClient = MockSupabaseClient();
      final mockQueryBuilder = MockSupabaseQueryBuilder();

      when(
        () => mockClient.from('log_activity'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        () => mockQueryBuilder.select(any()),
      ).thenThrow(Exception('Database error'));

      final container = makeContainer(mockClient);

      await expectLater(
        container.read(logActivityListProvider.future),
        throwsA(isA<Exception>()),
      );

      container.dispose();
    });
  });

  group('supabaseClientProviderForLog', () {
    test('returns default Supabase client', () {
      final container = ProviderContainer();
      final client = container.read(supabaseClientProviderForLog);

      expect(client, isA<SupabaseClient>());
      container.dispose();
    });
  });

  group('LogActivityNotifier', () {
    late MockSupabaseClient mockClient;
    late MockSupabaseQueryBuilder mockQueryBuilder;
    late MockGoTrueClient mockAuth;
    late MockUser mockUser;
    late ProviderContainer container;

    setUp(() {
      mockClient = MockSupabaseClient();
      mockQueryBuilder = MockSupabaseQueryBuilder();
      mockAuth = MockGoTrueClient();
      mockUser = MockUser();

      supabaseClientFactoryForLog = () => mockClient;
      container = makeContainer(mockClient);
      addTearDown(container.dispose);
    });

    test('createLog success updates state and inserts row', () async {
      when(
        () => mockClient.from('log_activity'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        () => mockQueryBuilder.insert(any()),
      ).thenAnswer((_) => FakeInsertBuilder());

      final notifier = container.read(logActivityNotifierProvider.notifier);
      expect(notifier.state.hasValue, true);

      await notifier.createLog(title: 'Create', userId: 'user-123');

      expect(notifier.state.hasValue, true);
      verify(() => mockClient.from('log_activity'));
      verify(() => mockQueryBuilder.insert(any()));

      container.dispose();
    });

    test('createLog error sets error state and rethrows', () async {
      when(
        () => mockClient.from('log_activity'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        () => mockQueryBuilder.insert(any()),
      ).thenThrow(Exception('Insert failed'));

      final notifier = container.read(logActivityNotifierProvider.notifier);

      await expectLater(
        notifier.createLog(title: 'Fail', userId: 'user-123'),
        throwsA(
          predicate((e) => e.toString().contains('Gagal membuat log activity')),
        ),
      );
      expect(notifier.state.hasError, true);

      container.dispose();
    });

    test('createLogWithCurrentUser success uses current user id', () async {
      when(
        () => mockClient.from('log_activity'),
      ).thenAnswer((_) => mockQueryBuilder);
      when(
        () => mockQueryBuilder.insert(any()),
      ).thenAnswer((_) => FakeInsertBuilder());
      when(() => mockClient.auth).thenReturn(mockAuth);
      when(() => mockAuth.currentUser).thenReturn(mockUser);
      when(() => mockUser.id).thenReturn('user-xyz');

      final notifier = container.read(logActivityNotifierProvider.notifier);

      await notifier.createLogWithCurrentUser(title: 'With current user');

      expect(notifier.state.hasValue, true);
      verify(() => mockClient.from('log_activity'));
      verify(() => mockQueryBuilder.insert(any()));
      verify(() => mockAuth.currentUser);

      container.dispose();
    });

    test(
      'createLogWithCurrentUser error sets error state and rethrows',
      () async {
        when(
          () => mockClient.from('log_activity'),
        ).thenAnswer((_) => mockQueryBuilder);
        when(
          () => mockQueryBuilder.insert(any()),
        ).thenThrow(Exception('Insert failed'));
        when(() => mockClient.auth).thenReturn(mockAuth);
        when(() => mockAuth.currentUser).thenReturn(mockUser);
        when(() => mockUser.id).thenReturn('user-xyz');

        final notifier = container.read(logActivityNotifierProvider.notifier);

        await expectLater(
          notifier.createLogWithCurrentUser(title: 'Fail current user'),
          throwsA(
            predicate(
              (e) => e.toString().contains('Gagal membuat log activity'),
            ),
          ),
        );
        expect(notifier.state.hasError, true);

        container.dispose();
      },
    );
  });
}
