// lib/presentation/providers/warga_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/warga/data/models/warga_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Datasource + Repository
import '../../data/datasources/warga_remote_datasource.dart';
import '../../data/repositories/warga_repository_impl.dart';

// Usecases
import '../../domain/usecases/get_all_warga.dart';
import '../../domain/usecases/get_warga_by_id.dart';
import '../../domain/usecases/create_warga.dart';
import '../../domain/usecases/update_warga.dart';
import '../../domain/usecases/delete_warga.dart';

// =========================================================
// SUPABASE CLIENT PROVIDER (jika pakai singleton kamu juga bisa)
// =========================================================
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});


// =========================================================
// DATASOURCE PROVIDER
// =========================================================
final wargaRemoteDataSourceProvider = Provider<WargaRemoteDataSourceImpl>((ref) {
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


// =========================================================
// PROVIDER: Get All Warga (Future Provider)
// =========================================================
final wargaListProvider = FutureProvider<List<WargaModel>>((ref) async {
  final ds = ref.read(wargaRemoteDataSourceProvider);
  return await ds.getAllWarga(); // langsung WargaModel
});


// =========================================================
// PROVIDER: Get Warga by ID (Future Provider Family)
// =========================================================
final wargaDetailProvider =
    FutureProvider.family((ref, int id) async {
  final usecase = ref.read(getWargaByIdUseCaseProvider);
  return await usecase(id);
});


// =========================================================
// OPTIONAL: STATE UNTUK FORM / CREATE / UPDATE WARGA
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
    );
  }

  void reset() {
    state = WargaFormState();
  }
}

// Provider untuk Form
final wargaFormProvider =
    StateNotifierProvider<WargaFormNotifier, WargaFormState>((ref) {
  return WargaFormNotifier();
});
