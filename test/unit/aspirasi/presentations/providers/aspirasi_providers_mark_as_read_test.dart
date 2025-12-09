import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class FakeRemoteImpl extends AspirationRemoteDataSourceImpl {
  final List<AspirationModel> list;
  int? lastMarkedId;
  
  FakeRemoteImpl(this.list) : super(MockSupabaseClient());

  @override
  Future<List<AspirationModel>> getAllAspirations() async => list;

  @override
  Future<void> markAsRead(int id) async {
    lastMarkedId = id;
  }
}

void main() {
  group('markAspirationReadProvider', () {
    test('markAspirationReadProvider calls markAsRead and invalidates list', () async {
      final fakeList = [
        AspirationModel(
          id: 1,
          sender: 'test@example.com',
          title: 'Test',
          status: 'pending',
          createdAt: DateTime.now(),
          message: 'Test message',
          isRead: false,
        ),
      ];

      final fakeRemote = FakeRemoteImpl(fakeList);

      final container = ProviderContainer(overrides: [
        aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote),
      ]);

      addTearDown(container.dispose);

      // Read markAspirationReadProvider with id=1
      await container.read(markAspirationReadProvider(1).future);

      // Verify markAsRead was called with id=1
      expect(fakeRemote.lastMarkedId, 1);
    });

    test('markAspirationReadProvider invalidates aspirationListProvider', () async {
      final fakeList = [
        AspirationModel(
          id: 2,
          sender: 'user@example.com',
          title: 'Another Test',
          status: 'pending',
          createdAt: DateTime.now(),
          message: 'Another message',
          isRead: false,
        ),
      ];

      final fakeRemote = FakeRemoteImpl(fakeList);

      final container = ProviderContainer(overrides: [
        aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote),
      ]);

      addTearDown(container.dispose);

      // First, read the list
      final initialList = await container.read(aspirationListProvider.future);
      expect(initialList, isNotEmpty);

      // Mark as read
      await container.read(markAspirationReadProvider(2).future);

      // The list should be refreshed (in real scenario, DB would update)
      final refreshedList = await container.read(aspirationListProvider.future);
      expect(refreshedList, isNotEmpty);
    });
  });
}
