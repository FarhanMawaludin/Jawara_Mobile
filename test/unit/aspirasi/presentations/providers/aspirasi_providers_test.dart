import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
// mocktail already imported earlier in this file
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/domain/usecases/get_all_aspirations.dart';
import 'package:mocktail/mocktail.dart';

class FakeRemote implements AspirationRemoteDataSource {
  final List<AspirationModel> list;
  FakeRemote(this.list);
  @override
  Future<List<AspirationModel>> getAllAspirations() async => list;

  @override
  Future<void> markAsRead(int id) async {
    // No-op for testing
  }
}

class MockSupabaseClient extends Mock implements SupabaseClient {}

/// A small concrete subclass of AspirationRemoteDataSourceImpl that overrides
/// `getAllAspirations` so we can provide fake rows while still matching the
/// provider's concrete type `AspirationRemoteDataSourceImpl`.
class FakeRemoteImpl extends AspirationRemoteDataSourceImpl {
  final List<AspirationModel> list;
  FakeRemoteImpl(this.list) : super(MockSupabaseClient());

  @override
  Future<List<AspirationModel>> getAllAspirations() async => list;

  @override
  Future<void> markAsRead(int id) async {
    // No-op for testing
  }
}

void main() {
  test('supabaseClientProviderForAspirasi is used to construct datasource', () {
    final mockClient = MockSupabaseClient();

    final container = ProviderContainer(overrides: [
      supabaseClientProviderForAspirasi.overrideWithValue(mockClient),
    ]);

    addTearDown(container.dispose);

    final ds = container.read(aspirationRemoteDataSourceProvider);
    // concrete implementation exposes `client`
    expect(ds.client, equals(mockClient));
  });

  test('aspirationListProvider returns data from datasource when overridden', () async {
    final fakeList = [
      AspirationModel(
        id: 1,
        sender: 'a@b.com',
        title: 'T1',
        status: 'pending',
        createdAt: DateTime.now(),
        message: 'M1',
      ),
    ];

    // Override the repository provider instead of the concrete datasource provider
    // because the original provider is typed to a concrete implementation
    // (`AspirationRemoteDataSourceImpl`). Overriding the repository keeps types simple.
    final container = ProviderContainer(overrides: [
      // Override the concrete remote datasource provider with our FakeRemoteImpl
      aspirationRemoteDataSourceProvider.overrideWithValue(FakeRemoteImpl(fakeList)),
    ]);

    addTearDown(container.dispose);

    final result = await container.read(aspirationListProvider.future);

    expect(result, fakeList);
  });

  test('provider chain builds repository and usecase and returns fake data', () async {
    final fakeList = [
      AspirationModel(id: 2, sender: 'x@x.com', title: 'X', status: 'done', createdAt: DateTime.now(), message: 'mx'),
    ];

    final mockClient = MockSupabaseClient();

    final container = ProviderContainer(overrides: [
      // ensure supabase client provider returns our mock
      supabaseClientProviderForAspirasi.overrideWithValue(mockClient),
      // override concrete datasource provider with a Fake impl that matches the concrete type
      aspirationRemoteDataSourceProvider.overrideWithValue(FakeRemoteImpl(fakeList)),
    ]);

    addTearDown(container.dispose);

    // repository provider should build successfully
    final repo = container.read(aspirationRepositoryProvider);
    expect(repo, isNotNull);

    // usecase provider should give a GetAllAspirations instance
    final usecase = container.read(getAllAspirationsProvider);
    expect(usecase, isA<GetAllAspirations>());

    // calling usecase should return our fake list
    final result = await usecase();
    expect(result, fakeList);

    // aspirationListProvider (future) should also resolve to fakeList
    final listFromProvider = await container.read(aspirationListProvider.future);
    expect(listFromProvider, fakeList);
  });
}
