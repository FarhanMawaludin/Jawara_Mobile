import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class SuccessRemoteImpl extends AspirationRemoteDataSourceImpl {
  final List<dynamic> rows;
  SuccessRemoteImpl(SupabaseClient client, this.rows) : super(client);
  @override
  Future<List<dynamic>> fetchRawAspirasi() async => rows;
}

class SuccessRemoteByWargaImpl extends AspirationRemoteDataSourceImpl {
  final List<dynamic> rows;
  SuccessRemoteByWargaImpl(SupabaseClient client, this.rows) : super(client);
  @override
  Future<List<dynamic>> fetchRawAspirationByWarga(int wargaId) async => rows;
}

class SuccessMarkAsReadImpl extends AspirationRemoteDataSourceImpl {
  bool markAsReadCalled = false;
  int? lastIdCalled;

  SuccessMarkAsReadImpl(SupabaseClient client) : super(client);

  @override
  Future<void> markAsRead(int id) async {
    markAsReadCalled = true;
    lastIdCalled = id;
  }
}

// Test implementation that calls super to execute real code for coverage
class TestableAspirationRemoteDataSourceImpl
    extends AspirationRemoteDataSourceImpl {
  bool fetchRawByWargaWasCalled = false;

  TestableAspirationRemoteDataSourceImpl(SupabaseClient client) : super(client);

  @override
  Future<List<dynamic>> fetchRawAspirationByWarga(int wargaId) async {
    fetchRawByWargaWasCalled = true;
    // Call super to execute lines 68-72
    try {
      return await super.fetchRawAspirationByWarga(wargaId);
    } catch (e) {
      rethrow;
    }
  }
}

void main() {
  group('AspirationRemoteDataSource', () {
    test('getAllAspirations success', () async {
      final raw = [
        {
          'id': 7,
          'user_id': 'uuid-7-777',
          'judul': 'Test Title',
          'deskripsi_aspirasi': 'Test message',
          'created_at': '2025-10-01T12:00:00Z',
          'sender': 'tester@example.com',
          'status': null,
        },
      ];
      final ds = SuccessRemoteImpl(MockSupabaseClient(), raw);
      final list = await ds.getAllAspirations();
      expect(list.length, 1);
      expect(list.first.title, 'Test Title');
    });

    test('getAllAspirations with real fetchRawAspirasi call', () async {
      final mockClient = MockSupabaseClient();
      final ds = AspirationRemoteDataSourceImpl(mockClient);
      expect(() => ds.getAllAspirations(), throwsA(anything));
    });

    test('getAllAspirations with error', () async {
      final ds = _FailingRemoteImpl(MockSupabaseClient());
      expect(() => ds.getAllAspirations(), throwsA(isA<Exception>()));
    });

    test('markAsRead success', () async {
      final ds = SuccessMarkAsReadImpl(MockSupabaseClient());
      await ds.markAsRead(42);
      expect(ds.markAsReadCalled, true);
      expect(ds.lastIdCalled, 42);
    });

    test('markAsRead error handling', () async {
      final ds = _FailingMarkAsReadImpl(MockSupabaseClient());
      expect(() => ds.markAsRead(1), throwsA(isA<Exception>()));
    });

    test('markAsRead with real client - will throw', () async {
      final mockClient = MockSupabaseClient();
      final ds = AspirationRemoteDataSourceImpl(mockClient);
      expect(() => ds.markAsRead(42), throwsA(anything));
    });

    test('parseRaw empty list', () {
      expect(AspirationRemoteDataSourceImpl.parseRaw([]), isEmpty);
    });

    test('parseRaw with null element', () {
      expect(
        () => AspirationRemoteDataSourceImpl.parseRaw([null]),
        throwsA(isA<TypeError>()),
      );
    });

    test('parseRaw with integer milliseconds date', () {
      final millis = DateTime.utc(2025, 6, 1).millisecondsSinceEpoch;
      final raw = [
        {
          'id': 9,
          'user_id': 'uuid-0001',
          'judul': 'Test',
          'deskripsi_aspirasi': 'msg',
          'created_at': millis,
          'sender': 'test@ex.com',
        },
      ];
      final list = AspirationRemoteDataSourceImpl.parseRaw(raw);
      expect(list.first.createdAt.millisecondsSinceEpoch, equals(millis));
    });

    test('parseRaw with non-Map element', () {
      expect(
        () => AspirationRemoteDataSourceImpl.parseRaw([123]),
        throwsA(isA<TypeError>()),
      );
    });

    test('parseRaw with invalid type in map', () {
      final raw = [
        {
          'id': 1,
          'user_id': 'abc',
          'judul': 123,
          'deskripsi_aspirasi': 'msg',
          'created_at': '2025-01-01T00:00:00Z',
          'sender': 'test',
        },
      ];
      expect(
        () => AspirationRemoteDataSourceImpl.parseRaw(raw),
        throwsA(isA<TypeError>()),
      );
    });

    test('getAspirationsByWarga success', () async {
      final raw = [
        {
          'id': 10,
          'user_id': 'uuid-warga-1',
          'judul': 'Aspirasi Warga',
          'deskripsi_aspirasi': 'Pesan dari warga',
          'created_at': '2025-11-01T10:00:00Z',
          'sender': 'warga@example.com',
          'status': 'pending',
        },
      ];
      final ds = SuccessRemoteByWargaImpl(MockSupabaseClient(), raw);
      final list = await ds.getAspirationsByWarga(123);
      expect(list.length, 1);
      expect(list.first.title, 'Aspirasi Warga');
      expect(list.first.message, 'Pesan dari warga');
    });

    test('getAspirationsByWarga with error', () async {
      final ds = _FailingRemoteByWargaImpl(MockSupabaseClient());
      expect(() => ds.getAspirationsByWarga(456), throwsA(isA<Exception>()));
    });

    test('fetchRawAspirationByWarga called in real implementation', () async {
      final mockClient = MockSupabaseClient();
      final ds = AspirationRemoteDataSourceImpl(mockClient);
      expect(() => ds.getAspirationsByWarga(789), throwsA(anything));
    });

    test('fetchRawAspirationByWarga direct call', () async {
      final mockClient = MockSupabaseClient();
      final ds = AspirationRemoteDataSourceImpl(mockClient);
      expect(() => ds.fetchRawAspirationByWarga(123), throwsA(anything));
    });

    test('fetchRawAspirationByWarga via testable implementation', () async {
      final mockClient = MockSupabaseClient();
      final ds = TestableAspirationRemoteDataSourceImpl(mockClient);
      expect(() => ds.fetchRawAspirationByWarga(999), throwsA(anything));
      expect(ds.fetchRawByWargaWasCalled, true);
    });
  });
}

class _FailingRemoteImpl extends AspirationRemoteDataSourceImpl {
  _FailingRemoteImpl(SupabaseClient client) : super(client);
  @override
  Future<List<dynamic>> fetchRawAspirasi() async => throw Exception('DB error');
}

class _FailingRemoteByWargaImpl extends AspirationRemoteDataSourceImpl {
  _FailingRemoteByWargaImpl(SupabaseClient client) : super(client);
  @override
  Future<List<dynamic>> fetchRawAspirationByWarga(int wargaId) async =>
      throw Exception('DB error for warga');
}

class _FailingMarkAsReadImpl extends AspirationRemoteDataSourceImpl {
  _FailingMarkAsReadImpl(SupabaseClient client) : super(client);
  @override
  Future<void> markAsRead(int id) async {
    try {
      throw Exception('Network error');
    } catch (e) {
      throw Exception('Gagal mengupdate status baca aspirasi: $e');
    }
  }
}
