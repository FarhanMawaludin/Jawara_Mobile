// lib/presentation/providers/warga_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/warga/data/models/warga_model.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/count_keluarga.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/count_warga.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Datasource + Repository
import '../../../data/datasources/warga_remote_datasource.dart';
import '../../../data/repositories/warga_repository_impl.dart';

// Usecases
import '../../../domain/usecases/warga/get_all_warga.dart';
import '../../../domain/usecases/warga/get_all_keluarga.dart';
import '../../../domain/usecases/warga/get_warga_by_id.dart';
import '../../../domain/usecases/warga/create_warga.dart';
import '../../../domain/usecases/warga/update_warga.dart';
import '../../../domain/usecases/warga/delete_warga.dart';
import '../../../domain/usecases/warga/search_warga.dart';
import '../../../domain/usecases/warga/get_warga_by_keluarga.dart';
import '../../../domain/usecases/warga/get_statistik_warga.dart';

// =========================================================
// SUPABASE CLIENT PROVIDER
// =========================================================
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// =========================================================
// DATASOURCE PROVIDER
// =========================================================
final wargaRemoteDataSourceProvider = Provider<WargaRemoteDataSourceImpl>((
  ref,
) {
  final client = ref.read(supabaseClientProvider);
  return WargaRemoteDataSourceImpl(client);
});

// =========================================================
// REPOSITORY PROVIDER
// =========================================================
final wargaRepositoryProvider = Provider<WargaRepositoryImpl>((ref) {
  final remote = ref.read(wargaRemoteDataSourceProvider);
  return WargaRepositoryImpl(remote);
});

// =========================================================
// USECASE PROVIDERS
// =========================================================
final getAllWargaProvider = Provider<GetAllWarga>((ref) {
  return GetAllWarga(ref.read(wargaRepositoryProvider));
});

final getAllKeluargaProvider = Provider<GetAllKeluarga>((ref) {
  return GetAllKeluarga(ref.read(wargaRepositoryProvider));
});

final getWargaByIdUseCaseProvider = Provider<GetWargaById>((ref) {
  return GetWargaById(ref.read(wargaRepositoryProvider));
});

final createWargaUseCaseProvider = Provider<CreateWarga>((ref) {
  return CreateWarga(ref.read(wargaRepositoryProvider));
});

final updateWargaUseCaseProvider = Provider<UpdateWarga>((ref) {
  return UpdateWarga(ref.read(wargaRepositoryProvider));
});

final deleteWargaUseCaseProvider = Provider<DeleteWarga>((ref) {
  return DeleteWarga(ref.read(wargaRepositoryProvider));
});

final searchWargaUseCaseProvider = Provider<SearchWarga>((ref) {
  return SearchWarga(ref.read(wargaRepositoryProvider));
});

final getWargaByKeluargaUseCaseProvider = Provider<GetWargaByKeluarga>((ref) {
  return GetWargaByKeluarga(ref.read(wargaRepositoryProvider));
});

final getStatistikWargaUseCaseProvider = Provider<GetStatistikWarga>((ref) {
  return GetStatistikWarga(ref.read(wargaRepositoryProvider));
});

final countKeluargaUseCaseProvider = Provider<CountKeluarga>((ref) {
  return CountKeluarga(ref.read(wargaRepositoryProvider));
});

final countWargaUseCaseProvider = Provider<CountWarga>((ref) {
  return CountWarga(ref.read(wargaRepositoryProvider));
});

// =========================================================
// PROVIDER: Get All Warga
// =========================================================
final wargaListProvider = FutureProvider<List<WargaModel>>((ref) async {
  final ds = ref.read(wargaRemoteDataSourceProvider);
  return await ds.getAllWarga();
});

// =========================================================
// PROVIDER: Get All Keluarga
// =========================================================
final keluargaListProvider = FutureProvider<List<WargaModel>>((ref) async {
  final ds = ref.read(wargaRemoteDataSourceProvider);
  return await ds.getAllKeluarga();
});

// =========================================================
// PROVIDER: Get Warga by ID
// =========================================================
final wargaDetailProvider = FutureProvider.family<WargaModel, int>((
  ref,
  id,
) async {
  final usecase = ref.read(getWargaByIdUseCaseProvider);
  final warga = await usecase(id);
  if (warga == null) {
    throw Exception("Warga not found");
  }
  return warga as WargaModel;
});

// =========================================================
// PROVIDER: Get Warga by Keluarga
// =========================================================
final wargaByKeluargaProvider = FutureProvider.family<List<WargaModel>, int>((
  ref,
  keluargaId,
) async {
  final usecase = ref.read(getWargaByKeluargaUseCaseProvider);
  final result = await usecase(keluargaId);
  return result.cast<WargaModel>();
});

// =========================================================
// SEARCH WARGA
// =========================================================
final searchInputProvider = StateProvider<String>((ref) => "");
final searchKeywordProvider = StateProvider<String>((ref) => "");

final searchWargaProvider = FutureProvider.autoDispose<List<WargaModel>>((
  ref,
) async {
  final keyword = ref.watch(searchKeywordProvider);
  if (keyword.isEmpty) return [];

  final usecase = ref.read(searchWargaUseCaseProvider);
  return (await usecase(keyword)).cast<WargaModel>();
});

// =========================================================
// COUNT PROVIDER
// =========================================================
final totalKeluargaProvider = FutureProvider<int>((ref) async {
  final usecase = ref.read(countKeluargaUseCaseProvider);
  return await usecase();
});

final totalWargaProvider = FutureProvider<int>((ref) async {
  final usecase = ref.read(countWargaUseCaseProvider);
  return await usecase();
});

// =========================================================
// FORM STATE
// =========================================================

class WargaFormState {
  final String nama;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String? roleKeluarga;
  final String? noTelp;
  final String? tempatLahir;
  final String? agama;
  final String? golonganDarah;
  final String? pekerjaan;
  final String? status;
  final String? pendidikan;

  WargaFormState({
    this.nama = '',
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.roleKeluarga,
    this.noTelp,
    this.tempatLahir,
    this.agama,
    this.golonganDarah,
    this.pekerjaan,
    this.status,
    this.pendidikan,
  });

  WargaFormState copyWith({
    String? nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? roleKeluarga,
    String? noTelp,
    String? tempatLahir,
    String? agama,
    String? golonganDarah,
    String? pekerjaan,
    String? status,
    String? pendidikan,
  }) {
    return WargaFormState(
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      roleKeluarga: roleKeluarga ?? this.roleKeluarga,
      noTelp: noTelp ?? this.noTelp,
      tempatLahir: tempatLahir ?? this.tempatLahir,
      agama: agama ?? this.agama,
      golonganDarah: golonganDarah ?? this.golonganDarah,
      pekerjaan: pekerjaan ?? this.pekerjaan,
      status: status ?? this.status,
      pendidikan: pendidikan ?? this.pendidikan,
    );
  }
}

class WargaFormNotifier extends StateNotifier<WargaFormState> {
  WargaFormNotifier() : super(WargaFormState());

  void update({
    String? nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? roleKeluarga,
    String? noTelp,
    String? tempatLahir,
    String? agama,
    String? golonganDarah,
    String? pekerjaan,
    String? status,
    String? pendidikan,
  }) {
    state = state.copyWith(
      nama: nama,
      nik: nik,
      jenisKelamin: jenisKelamin,
      tanggalLahir: tanggalLahir,
      roleKeluarga: roleKeluarga,
      noTelp: noTelp,
      tempatLahir: tempatLahir,
      agama: agama,
      golonganDarah: golonganDarah,
      pekerjaan: pekerjaan,
      status: status,
      pendidikan: pendidikan,
    );
  }

  void reset() {
    state = WargaFormState();
  }
}

final wargaFormProvider =
    StateNotifierProvider<WargaFormNotifier, WargaFormState>((ref) {
      return WargaFormNotifier();
    });
