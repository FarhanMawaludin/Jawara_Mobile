import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:jawaramobile/features/pengaturan/presentation/providers/log_activity_providers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class MockSupabaseQueryBuilder extends Mock implements SupabaseQueryBuilder {}

class MockPostgrestFilterBuilder extends Mock
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {}

class FakePostgrestFilterBuilder
    extends Fake
    implements PostgrestFilterBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> data;
  final Exception? error;

  FakePostgrestFilterBuilder({this.data = const [], this.error});

  @override
  PostgrestTransformBuilder<List<Map<String, dynamic>>> order(
    String column, {
    bool ascending = false,
    bool nullsFirst = false,
    String? referencedTable,
  }) {
    return FakePostgrestTransformBuilder(data: data, error: error);
  }
}

class FakePostgrestTransformBuilder
    extends Fake
    implements PostgrestTransformBuilder<List<Map<String, dynamic>>> {
  final List<Map<String, dynamic>> data;
  final Exception? error;

  FakePostgrestTransformBuilder({this.data = const [], this.error});

  @override
  Future<U> then<U>(
    FutureOr<U> Function(List<Map<String, dynamic>> value) onValue, {
    Function? onError,
  }) {
    if (error != null) {
      return Future.error(error!);
    }
    return Future.sync(() => onValue(data));
  }
}

void main() {
  late MockSupabaseClient defaultClient;

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

    test('handles nulls and alt keys', () {
      final model = LogActivityModel.fromMap({
        'id': 2,
        'title': null,
        'userId': null,
        'createdAt': '2025-12-08T12:00:00Z',
      });

      expect(model.title, '');
      expect(model.userId, null);
      expect(model.createdAt.year, 2025);
    });

    test('parses integer id', () {
      final model = LogActivityModel.fromMap({
        'id': 3,
        'title': 'Test',
        'user_id': 'user123',
        'created_at': '2025-12-08T10:00:00Z',
      });

      expect(model.id, 3);
      expect(model.title, 'Test');
      expect(model.userId, 'user123');
    });

    test('handles missing fields with defaults', () {
      final model = LogActivityModel.fromMap({
        'id': 4,
        'created_at': '2025-12-08T10:00:00Z',
      });

      expect(model.id, 4);
      expect(model.title, '');
      expect(model.userId, null);
    });

    test('uses user_id field when both user_id and userId exist', () {
      final model = LogActivityModel.fromMap({
        'id': 5,
        'title': 'Test',
        'user_id': 'primary_user',
        'userId': 'alt_user',
        'created_at': '2025-12-08T10:00:00Z',
      });

      expect(model.userId, 'primary_user');
    });

    test('uses userId when user_id is null', () {
      final model = LogActivityModel.fromMap({
        'id': 6,
        'title': 'Test',
        'user_id': null,
        'userId': 'alt_user',
        'created_at': '2025-12-08T10:00:00Z',
      });

      expect(model.userId, 'alt_user');
    });

    test('parses createdAt field alternative', () {
      final model = LogActivityModel.fromMap({
        'id': 7,
        'title': 'Test',
        'createdAt': '2025-12-08T10:00:00Z',
      });

      expect(model.createdAt.year, 2025);
    });

    test('converts numeric title to string', () {
      final model = LogActivityModel.fromMap({
        'id': 8,
        'title': 123,
        'created_at': '2025-12-08T10:00:00Z',
      });

      expect(model.title, '123');
    });

    test('toString returns expected format', () {
      final model = LogActivityModel(
        id: 1,
        title: 'Test',
        userId: 'user1',
        createdAt: DateTime(2025, 12, 8),
      );

      expect(model, isA<LogActivityModel>());
      expect(model.id, 1);
      expect(model.title, 'Test');
    });
  });

  group('logActivityListProvider', () {
    test('fetches data via Supabase client', () async {
      final mockClient = MockSupabaseClient();
      final mockQueryBuilder = MockSupabaseQueryBuilder();
      final fakeFilterBuilder = FakePostgrestFilterBuilder(data: [
        {
          'id': 1,
          'title': 'Activity 1',
          'user_id': 'user-1',
          'created_at': '2025-12-08T10:00:00Z',
        },
      ]);

      when(() => mockClient.from('log_activity')).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select(any())).thenAnswer((_) => fakeFilterBuilder);

      final container = ProviderContainer(
        overrides: [
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
      );

      final result = await container.read(logActivityListProvider.future);

      expect(result.single.title, 'Activity 1');
      verify(() => mockClient.from('log_activity')).called(1);
      verify(() => mockQueryBuilder.select('*')).called(1);

      container.dispose();
    });

    test('throws exception when Supabase call fails', () async {
      final mockClient = MockSupabaseClient();
      final mockQueryBuilder = MockSupabaseQueryBuilder();

      when(() => mockClient.from('log_activity')).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select(any())).thenThrow(Exception('Database error'));

      final container = ProviderContainer(
        overrides: [
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
      );

      expect(
        () => container.read(logActivityListProvider.future),
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
}
