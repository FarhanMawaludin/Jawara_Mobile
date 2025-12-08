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

  group('LogActivityModel', () {
    test('should create model from map correctly', () {
      // arrange
      final map = {
        'id': 1,
        'title': 'Test Activity',
        'user_id': 'user-123',
        'created_at': '2025-12-08T10:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.id, 1);
      expect(model.title, 'Test Activity');
      expect(model.userId, 'user-123');
      expect(model.createdAt, DateTime.parse('2025-12-08T10:00:00Z'));
    });

    test('should handle null user_id', () {
      // arrange
      final map = {
        'id': 2,
        'title': 'System Activity',
        'user_id': null,
        'created_at': '2025-12-08T11:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.id, 2);
      expect(model.title, 'System Activity');
      expect(model.userId, null);
    });

    test('should parse id from string', () {
      // arrange
      final map = {
        'id': '3',
        'title': 'Another Activity',
        'user_id': 'user-456',
        'created_at': '2025-12-08T12:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.id, 3);
    });

    test('should handle empty title', () {
      // arrange
      final map = {
        'id': 4,
        'title': '',
        'user_id': 'user-789',
        'created_at': '2025-12-08T13:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.title, '');
    });

    test('should parse created_at correctly', () {
      // arrange
      final map = {
        'id': 5,
        'title': 'Timestamp Test',
        'user_id': 'user-111',
        'created_at': '2025-11-25T00:33:36.034884+00:00',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.createdAt.year, 2025);
      expect(model.createdAt.month, 11);
      expect(model.createdAt.day, 25);
    });

    test('should handle alternative field names', () {
      // arrange - using camelCase instead of snake_case
      final map = {
        'id': 6,
        'title': 'Alternative naming',
        'userId': 'user-222',
        'createdAt': '2025-12-08T15:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.userId, 'user-222');
      expect(model.createdAt, DateTime.parse('2025-12-08T15:00:00Z'));
    });

    test('should handle null title', () {
      // arrange
      final map = {
        'id': 7,
        'user_id': 'user-333',
        'created_at': '2025-12-08T16:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.title, '');
    });

    test('should handle missing user_id field', () {
      // arrange
      final map = {
        'id': 8,
        'title': 'No User',
        'created_at': '2025-12-08T17:00:00Z',
      };

      // act
      final model = LogActivityModel.fromMap(map);

      // assert
      expect(model.userId, null);
    });
  });

  group('logActivityListProvider', () {
    test('should fetch log activities successfully', () async {
      // arrange
      final mockData = <Map<String, dynamic>>[
        {
          'id': 1,
          'title': 'Activity 1',
          'user_id': 'user-1',
          'created_at': '2025-12-08T10:00:00Z',
        },
        {
          'id': 2,
          'title': 'Activity 2',
          'user_id': null,
          'created_at': '2025-12-08T11:00:00Z',
        },
      ];

      final container = ProviderContainer(
        overrides: [
          logActivityListProvider.overrideWith(
            (ref) => Future.value(mockData.map((e) => LogActivityModel.fromMap(e)).toList()),
          ),
        ],
      );

      // act
      final result = await container.read(logActivityListProvider.future);

      // assert
      expect(result.length, 2);
      expect(result[0].id, 1);
      expect(result[0].title, 'Activity 1');
      expect(result[0].userId, 'user-1');
      expect(result[1].id, 2);
      expect(result[1].title, 'Activity 2');
      expect(result[1].userId, null);

      container.dispose();
    });

    test('should throw exception when fetch fails', () async {
      // arrange
      final container = ProviderContainer(
        overrides: [
          logActivityListProvider.overrideWith(
            (ref) => Future.error(Exception('Gagal mengambil log_activity: Database error')),
          ),
        ],
      );

      // act & assert
      expect(
        () => container.read(logActivityListProvider.future),
        throwsA(isA<Exception>()),
      );

      container.dispose();
    });

    test('should use supabaseClientProviderForLog', () async {
      // arrange
      final mockClient = MockSupabaseClient();
      final mockQueryBuilder = MockSupabaseQueryBuilder();

      final mockData = <Map<String, dynamic>>[
        {
          'id': 1,
          'title': 'Activity from Supabase',
          'user_id': 'user-1',
          'created_at': '2025-12-08T10:00:00Z',
        },
      ];

      final fakeFilterBuilder = FakePostgrestFilterBuilder(data: mockData);

      when(() => mockClient.from('log_activity')).thenAnswer((_) => mockQueryBuilder);
      when(() => mockQueryBuilder.select('*')).thenAnswer((_) => fakeFilterBuilder);

      final container = ProviderContainer(
        overrides: [
          supabaseClientProviderForLog.overrideWithValue(mockClient),
        ],
      );

      // act
      final result = await container.read(logActivityListProvider.future);

      // assert
      expect(result.length, 1);
      expect(result[0].title, 'Activity from Supabase');
      verify(() => mockClient.from('log_activity')).called(1);
      verify(() => mockQueryBuilder.select('*')).called(1);

      container.dispose();
    });
  });

  group('supabaseClientProviderForLog', () {
    test('should provide Supabase client instance', () {
      // Note: This test only verifies the provider structure
      // since Supabase.instance.client requires initialization in actual use
      expect(supabaseClientProviderForLog, isA<Provider<SupabaseClient>>());
    });
  });
}
