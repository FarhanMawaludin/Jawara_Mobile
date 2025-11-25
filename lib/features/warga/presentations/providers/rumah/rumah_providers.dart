import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Datasource + Repository
import '../../../data/datasources/rumah_remote_datasource.dart';
import '../../../data/repositories/rumah_repository_impl.dart';

// Usecases
import '../../../domain/usecases/rumah/get_all_rumah.dart';
import '../../../domain/usecases/rumah/get_rumah_by_id.dart';
import '../../../domain/usecases/rumah/get_rumah_by_keluarga.dart';
import '../../../domain/usecases/rumah/create_rumah.dart';
import '../../../domain/usecases/rumah/update_rumah.dart';
import '../../../domain/usecases/rumah/delete_rumah.dart';
import '../../../domain/usecases/rumah/search_rumah.dart';

// =========================================================
// SUPABASE CLIENT PROVIDER
// =========================================================
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// =========================================================
// DATASOURCE PROVIDER
// =========================================================
final rumahRemoteDataSourceProvider =
    Provider<RumahRemoteDataSourceImpl>((ref) {
  final client = ref.read(supabaseClientProvider);
  return RumahRemoteDataSourceImpl(client);
});

// =========================================================
// REPOSITORY PROVIDER
// =========================================================
final rumahRepositoryProvider = Provider<RumahRepositoryImpl>((ref) {
  final remote = ref.read(rumahRemoteDataSourceProvider);
  return RumahRepositoryImpl(remote);
});

// =========================================================
// USECASE PROVIDERS
// =========================================================
final getAllRumahProvider = Provider<GetAllRumah>((ref) {
  return GetAllRumah(ref.read(rumahRepositoryProvider));
});

final getRumahByIdProvider = Provider<GetRumahById>((ref) {
  return GetRumahById(ref.read(rumahRepositoryProvider));
});

final getRumahByKeluargaProvider = Provider<GetRumahByKeluarga>((ref) {
  return GetRumahByKeluarga(ref.read(rumahRepositoryProvider));
});

final createRumahProvider = Provider<CreateRumah>((ref) {
  return CreateRumah(ref.read(rumahRepositoryProvider));
});

final updateRumahProvider = Provider<UpdateRumah>((ref) {
  return UpdateRumah(ref.read(rumahRepositoryProvider));
});

final deleteRumahProvider = Provider<DeleteRumah>((ref) {
  return DeleteRumah(ref.read(rumahRepositoryProvider));
});

final searchRumahUsecaseProvider = Provider<SearchRumah>((ref) {
  return SearchRumah(ref.read(rumahRepositoryProvider));
});

// =========================================================
// FUTURE PROVIDERS
// =========================================================
final rumahListProvider = FutureProvider<List<Rumah>>((ref) async {
  final usecase = ref.read(getAllRumahProvider);
  return await usecase();
});

final rumahDetailProvider =
    FutureProvider.family<Rumah?, int>((ref, id) async {
  final usecase = ref.read(getRumahByIdProvider);
  return await usecase(id);
});

final rumahByKeluargaProvider =
    FutureProvider.family<List<Rumah>, int>((ref, keluargaId) async {
  final usecase = ref.read(getRumahByKeluargaProvider);
  return await usecase(keluargaId);
});

// =========================================================
// SEARCH STATE PROVIDERS
// =========================================================

// Input user (realtime saat mengetik)
final searchRumahInputProvider = StateProvider<String>((ref) => "");

// Keyword final (dipakai untuk search)
final searchRumahKeywordProvider = StateProvider<String>((ref) => "");

// Hasil Pencarian
final searchRumahResultProvider =
    FutureProvider.autoDispose<List<Rumah>>((ref) async {
  final keyword = ref.watch(searchRumahKeywordProvider);

  if (keyword.isEmpty) return [];

  final usecase = ref.read(searchRumahUsecaseProvider);
  return await usecase(keyword);
});

// =========================================================
// FORM PROVIDER
// =========================================================

class RumahFormState {
  final String? blok;
  final String? nomorRumah;
  final String? alamatLengkap;

  RumahFormState({
    this.blok,
    this.nomorRumah,
    this.alamatLengkap,
  });

  RumahFormState copyWith({
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  }) {
    return RumahFormState(
      blok: blok ?? this.blok,
      nomorRumah: nomorRumah ?? this.nomorRumah,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
    );
  }
}

class RumahFormNotifier extends StateNotifier<RumahFormState> {
  RumahFormNotifier() : super(RumahFormState());

  void update({
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  }) {
    state = state.copyWith(
      blok: blok,
      nomorRumah: nomorRumah,
      alamatLengkap: alamatLengkap,
    );
  }

  void reset() => state = RumahFormState();
}

final rumahFormProvider =
    StateNotifierProvider<RumahFormNotifier, RumahFormState>((ref) {
  return RumahFormNotifier();
});
