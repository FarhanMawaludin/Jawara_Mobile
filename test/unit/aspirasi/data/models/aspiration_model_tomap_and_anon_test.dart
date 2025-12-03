import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';

void main() {
  test('toMap includes id when present and created_at as ISO string', () {
    final dt = DateTime.utc(2025, 6, 1, 12, 0, 0);
    final model = AspirationModel(
      id: 999,
      sender: 'Siti',
      title: 'T',
      status: 'done',
      createdAt: dt,
      message: 'm',
    );

    final map = model.toMap();
    expect(map['id'], 999);
    expect(map['sender'], 'Siti');
    expect(map['title'], 'T');
    expect(map['status'], 'done');
    expect(map['message'], 'm');
    expect(map['created_at'], dt.toIso8601String());
  });

  test('toMap omits id when null', () {
    final dt = DateTime.utc(2025, 6, 2, 12, 0, 0);
    final model = AspirationModel(
      id: null,
      sender: 'Anonim',
      title: 'T2',
      status: 'new',
      createdAt: dt,
      message: 'mm',
    );

    final map = model.toMap();
    expect(map.containsKey('id'), isFalse);
    expect(map['created_at'], dt.toIso8601String());
  });

  test('fromMap uses "Anon" when sender is not a String', () {
    final map = {
      'id': 777,
      'sender': 12345, // non-string -> should become 'Anon'
      'judul': 'X',
      'deskripsi_aspirasi': 'Y',
      'created_at': '2025-01-01T00:00:00Z',
    };

    final model = AspirationModel.fromMap(Map<String, dynamic>.from(map));
    expect(model.sender, 'Anon');
  });
}
