import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Datasource + Repository
import '../../../data/datasources/mutasi_remote_datasource.dart';
import '../../../data/repositories/mutasi_repository_impl.dart';

// Usecases
import '../../../domain/usecases/mutasi/get_all_mutasi.dart';
import '../../../domain/usecases/mutasi/get_mutasi_by_id.dart';
import '../../../domain/usecases/mutasi/get_mutasi_by_keluarga.dart';
import '../../../domain/usecases/mutasi/create_mutasi.dart';

// =========================================================
// SUPABASE CLIENT PROVIDER
// =========================================================
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// =========================================================
// DATASOURCE PROVIDER
// =========================================================
final mutasiRemoteDataSourceProvider = Provider<MutasiRemoteDatasourceImpl>((
  ref,
) {
  final client = ref.read(supabaseClientProvider);
  return MutasiRemoteDatasourceImpl(client);
});

// =========================================================
// REPOSITORY PROVIDER
// =========================================================
final mutasiRepositoryProvider = Provider<MutasiRepositoryImpl>((ref) {
  final remote = ref.read(mutasiRemoteDataSourceProvider);
  return MutasiRepositoryImpl(remote);
});

// =========================================================
// USECASE PROVIDERS
// =========================================================
final getAllMutasiProvider = Provider<GetAllMutasi>((ref) {
  return GetAllMutasi(ref.read(mutasiRepositoryProvider));
});

final getMutasiByIdProvider = Provider<GetMutasiById>((ref) {
  return GetMutasiById(ref.read(mutasiRepositoryProvider));
});

final getMutasiByKeluargaProvider = Provider<GetMutasiByKeluarga>((ref) {
  return GetMutasiByKeluarga(ref.read(mutasiRepositoryProvider));
});

final createMutasiProvider = Provider<CreateMutasi>((ref) {
  return CreateMutasi(ref.read(mutasiRepositoryProvider));
});

// =========================================================
// FUTURE PROVIDER
// =========================================================

final mutasiListProvider = FutureProvider<List<Mutasi>>((ref) async {
  final usecase = ref.read(getAllMutasiProvider);
  return await usecase();
});

final mutasiDetailProvider = FutureProvider.family<Mutasi?, int>((
  ref,
  id,
) async {
  final usecase = ref.read(getMutasiByIdProvider);
  return await usecase(id);
});
