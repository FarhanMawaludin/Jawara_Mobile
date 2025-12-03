import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class ThrowingRemoteImpl extends AspirationRemoteDataSourceImpl {
  ThrowingRemoteImpl(SupabaseClient client) : super(client);

  @override
  Future<List<AspirationModel>> getAllAspirations() async {
    throw Exception('datasource boom');
  }
}

void main() {
  test('getAllAspirations catches client errors and rethrows as Exception', () async {
    final mockClient = MockSupabaseClient();

    // If client.from(...) throws, the datasource should catch and rethrow
    when(() => mockClient.from(any())).thenThrow(Exception('network error'));

    final ds = AspirationRemoteDataSourceImpl(mockClient);

    expect(() async => await ds.getAllAspirations(), throwsA(isA<Exception>()));
  });

  test('aspirationListProvider propagates exception when datasource throws', () async {
    final container = ProviderContainer(overrides: [
      aspirationRemoteDataSourceProvider.overrideWithValue(ThrowingRemoteImpl(MockSupabaseClient())),
    ]);

    addTearDown(container.dispose);

    // reading the future should throw because datasource throws
    expect(container.read(aspirationListProvider.future), throwsA(isA<Exception>()));
  });
}
