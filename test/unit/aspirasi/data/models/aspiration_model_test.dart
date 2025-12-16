import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';

void main() {
  group('AspirationModel', () {
    test('fromMap with various field mappings', () {
      final map = {
        'id': 100,
        'user_id': 'abc-123',
        'judul': 'Test Title',
        'deskripsi_aspirasi': 'Test Message',
        'created_at': '2025-01-01T00:00:00Z',
        'status': 'pending',
      };
      final model = AspirationModel.fromMap(map);
      expect(model.id, 100);
      expect(model.title, 'Test Title');
      expect(model.message, 'Test Message');
    });

    test('fromMap with integer milliseconds date', () {
      final millis = DateTime(2025, 1, 2).millisecondsSinceEpoch;
      final map = {'id': 101, 'user_id': 'u1', 'judul': 'T', 'deskripsi_aspirasi': 'M', 'created_at': millis};
      final model = AspirationModel.fromMap(map);
      expect(model.createdAt.millisecondsSinceEpoch, millis);
    });

    test('fromMap with DateTime value', () {
      final dt = DateTime.utc(2024, 12, 31);
      final map = {'id': 102, 'judul': 'T', 'deskripsi_aspirasi': 'M', 'created_at': dt};
      final model = AspirationModel.fromMap(map);
      expect(model.createdAt, dt);
    });

    test('fromMap with invalid date string falls back to now', () {
      final map = {'id': 103, 'judul': 'T', 'deskripsi_aspirasi': 'M', 'created_at': 'invalid-date-string'};
      final model = AspirationModel.fromMap(map);
      expect(model.createdAt.year, DateTime.now().year);
    });

    test('fromMap with UUID sender shortened', () {
      final map = {'id': 201, 'user_id': 'fa90aa61-2219-4d85-8977-2c5fea123456', 'judul': 'T', 'deskripsi_aspirasi': 'M', 'created_at': '2025-01-01T00:00:00Z'};
      final model = AspirationModel.fromMap(map);
      expect(model.sender, 'fa90aa61');
    });

    test('fromMap with non-string sender defaults to Anon', () {
      final map = {'id': 777, 'sender': 12345, 'judul': 'X', 'deskripsi_aspirasi': 'Y', 'created_at': '2025-01-01T00:00:00Z'};
      final model = AspirationModel.fromMap(map);
      expect(model.sender, 'Anon');
    });

    test('fromMap with string id parsed correctly', () {
      final map = {'id': '123', 'judul': 'T', 'deskripsi_aspirasi': 'M', 'created_at': '2025-01-01T00:00:00Z'};
      final model = AspirationModel.fromMap(map);
      expect(model.id, 123);
    });

    test('toMap includes all fields', () {
      final dt = DateTime.utc(2025, 6, 1);
      final model = AspirationModel(id: 999, sender: 'Siti', title: 'T', status: 'done', createdAt: dt, message: 'm');
      final map = model.toMap();
      expect(map['id'], 999);
      expect(map['sender'], 'Siti');
      expect(map['created_at'], dt.toIso8601String());
    });

    test('toMap omits id when null', () {
      final model = AspirationModel(id: null, sender: 'A', title: 'T', status: 's', createdAt: DateTime.now(), message: 'm');
      final map = model.toMap();
      expect(map.containsKey('id'), isFalse);
    });
  });
}
