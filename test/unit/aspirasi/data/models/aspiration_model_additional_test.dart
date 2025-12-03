import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';

void main() {
  test('fromMap parses created_at as int milliseconds since epoch', () {
    final millis = DateTime(2025, 1, 2, 3, 4, 5).millisecondsSinceEpoch;
    final map = {
      'id': 100,
      'user_id': 'abc-123-def',
      'judul': 'Test',
      'deskripsi_aspirasi': 'x',
      'created_at': millis,
      'status': 'pending',
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.createdAt.millisecondsSinceEpoch, millis);
  });

  test('fromMap handles DateTime value for created_at', () {
    final dt = DateTime.utc(2024, 12, 31, 23, 59);
    final map = {
      'id': 101,
      'user_id': 'uid',
      'judul': 'T2',
      'deskripsi_aspirasi': 'y',
      'created_at': dt,
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.createdAt, dt);
  });

  test('fromMap falls back to empty strings when title/message missing', () {
    final map = {
      'id': 102,
      'user_id': 'u1',
      'created_at': '2025-01-01T00:00:00Z',
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.title, isA<String>());
    expect(model.message, isA<String>());
  });

  test('fromMap parses id when id is a numeric string', () {
    final map = {
      'id': '123',
      'user_id': 'u2',
      'judul': 'Has string id',
      'deskripsi_aspirasi': 'ok',
      'created_at': '2025-02-02T02:02:02Z',
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.id, 123);
  });

  test('fromMap falls back to sender alternatives and shortens UUID', () {
    final mapNama = {
      'id': 200,
      'nama': 'Budi',
      'judul': 'n',
      'deskripsi_aspirasi': 'm',
      'created_at': '2025-03-03T03:03:03Z',
    };

    final modelNama = AspirationModel.fromMap(Map<String, dynamic>.from(mapNama));
    expect(modelNama.sender, 'Budi');

    final mapUuid = {
      'id': 201,
      'user_id': 'fa90aa61-2219-4d85-8977-2c5fea123456',
      'judul': 'n2',
      'deskripsi_aspirasi': 'm2',
      'created_at': '2025-03-03T03:03:03Z',
    };

    final modelUuid = AspirationModel.fromMap(Map<String, dynamic>.from(mapUuid));
    // UUID should be shortened to first 8 characters
    expect(modelUuid.sender, 'fa90aa61');
  });

  test('fromMap defaults status to Pending when null', () {
    final map = {
      'id': 300,
      'user_id': 'u3',
      'judul': 's',
      'deskripsi_aspirasi': 'd',
      'created_at': '2025-04-04T04:04:04Z',
      'status': null,
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.status, 'Pending');
  });

  test('fromMap accepts alternative keys for title and message', () {
    final map = {
      'id': 400,
      'user_id': 'u4',
      'subject': 'From subject',
      'pesan': 'From pesan',
      'created_at': '2025-05-05T05:05:05Z',
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.title, 'From subject');
    expect(model.message, 'From pesan');
  });

  test('fromMap falls back to now when created_at is invalid string', () {
    final before = DateTime.now();
    final map = {
      'id': 500,
      'user_id': 'u5',
      'judul': 'bad date',
      'deskripsi_aspirasi': 'd',
      'created_at': 'not-a-date',
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    final after = DateTime.now();

    expect(model.createdAt.isAfter(before) || model.createdAt.isAtSameMomentAs(before), isTrue);
    expect(model.createdAt.isBefore(after) || model.createdAt.isAtSameMomentAs(after), isTrue);
  });
}
