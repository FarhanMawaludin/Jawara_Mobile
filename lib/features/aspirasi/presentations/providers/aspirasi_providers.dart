import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../data/datasources/aspiration_remote_datasource.dart';
import '../../data/repositories/aspiration_repository_impl.dart';
import '../../domain/usecases/get_all_aspirations.dart';
import '../../data/models/aspiration_model.dart';

// SUPABASE CLIENT PROVIDER
final supabaseClientProviderForAspirasi = Provider<SupabaseClient>((ref) => Supabase.instance.client);

// DATASOURCE
final aspirationRemoteDataSourceProvider = Provider<AspirationRemoteDataSourceImpl>((ref) {
  final client = ref.read(supabaseClientProviderForAspirasi);
  return AspirationRemoteDataSourceImpl(client);
});

// REPOSITORY
final aspirationRepositoryProvider = Provider<AspirationRepositoryImpl>((ref) {
  final remote = ref.read(aspirationRemoteDataSourceProvider);
  return AspirationRepositoryImpl(remote);
});

// USECASE
final getAllAspirationsProvider = Provider<GetAllAspirations>((ref) {
  return GetAllAspirations(ref.read(aspirationRepositoryProvider));
});

// FutureProvider used by the UI
final aspirationListProvider = FutureProvider<List<AspirationModel>>((ref) async {
  final ds = ref.read(aspirationRemoteDataSourceProvider);
  final list = await ds.getAllAspirations();
  return list;
});

// Provider untuk filter aspirasi by warga
final aspirationByWargaProvider = FutureProvider.family<List<AspirationModel>, int>((ref, wargaId) async {
  final ds = ref.read(aspirationRemoteDataSourceProvider);
  final list = await ds.getAspirationsByWarga(wargaId);
  return list;
});

// Provider untuk mark as read
final markAspirationReadProvider = FutureProvider.family<void, int>((ref, id) async {
  final ds = ref.read(aspirationRemoteDataSourceProvider);
  await ds.markAsRead(id);
  // Invalidate the list so it refreshes
  ref.invalidate(aspirationListProvider);
});
