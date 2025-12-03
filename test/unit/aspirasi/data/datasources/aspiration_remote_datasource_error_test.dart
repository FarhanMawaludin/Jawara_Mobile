import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';

void main() {
  test('parseRaw returns empty list for empty input', () {
    final list = AspirationRemoteDataSourceImpl.parseRaw([]);
    expect(list, isA<List<AspirationModel>>());
    expect(list, isEmpty);
  });

  test('parseRaw throws when encountering null element', () {
    expect(() => AspirationRemoteDataSourceImpl.parseRaw([null]), throwsA(isA<TypeError>()));
  });

  test('parseRaw throws when encountering non-Map element', () {
    expect(() => AspirationRemoteDataSourceImpl.parseRaw([123]), throwsA(isA<TypeError>()));
  });

  test('parseRaw throws when map contains non-string title', () {
    final raw = [
      {
        'id': 1,
        'user_id': 'abc-1234-uuid',
        'judul': 123, // invalid type for title
        'deskripsi_aspirasi': 'some message',
        'created_at': '2025-01-01T00:00:00Z',
        'sender': 'someone',
      }
    ];

    expect(() => AspirationRemoteDataSourceImpl.parseRaw(raw), throwsA(isA<TypeError>()));
  });

  test('parseRaw parses created_at as integer milliseconds', () {
    final millis = DateTime.utc(2025, 6, 1).millisecondsSinceEpoch;
    final raw = [
      {
        'id': 9,
        'user_id': 'uuid-0001-2222',
        'judul': 'Test int created_at',
        'deskripsi_aspirasi': 'message',
        'created_at': millis,
        'sender': 'tester@example.com',
      }
    ];

    final list = AspirationRemoteDataSourceImpl.parseRaw(raw);
    expect(list, isNotEmpty);
    final item = list.first;
    expect(item.createdAt.millisecondsSinceEpoch, equals(millis));
  });
}
