import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class SuccessRemoteImpl extends AspirationRemoteDataSourceImpl {
  final List<dynamic> rows;
  SuccessRemoteImpl(SupabaseClient client, this.rows) : super(client);

  @override
  Future<List<dynamic>> fetchRawAspirasi() async => rows;
}

void main() {
  test('getAllAspirations returns mapped list on successful client response', () async {
    final mockClient = MockSupabaseClient();

    final raw = [
      {
        'id': 7,
        'user_id': 'uuid-7-777',
        'judul': 'Test Title',
        'deskripsi_aspirasi': 'Test message',
        'created_at': '2025-10-01T12:00:00Z',
        'sender': 'tester@example.com',
        'status': null,
      }
    ];

    final ds = SuccessRemoteImpl(mockClient, raw);

    final list = await ds.getAllAspirations();

    expect(list, isA<List<AspirationModel>>());
    expect(list.length, 1);
    final item = list.first;
    expect(item.id, 7);
    expect(item.title, 'Test Title');
    expect(item.message, 'Test message');
    expect(item.sender, 'tester@example.com');
  });
}
