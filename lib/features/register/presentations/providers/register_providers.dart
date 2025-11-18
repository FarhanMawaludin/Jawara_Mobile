// lib/presentation/providers/register_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/register_account.dart';
import '../../domain/usecases/create_keluarga_and_warga.dart';
import '../../domain/usecases/create_rumah.dart';
import '../../data/repositories/register_repository_impl.dart';
import '../../data/datasources/supabase_remote_datasource.dart';


// =========================================================
// REGISTER REPOSITORY PROVIDER
// Menghubungkan repository dengan datasource Supabase
// =========================================================
final registerRepositoryProvider = Provider<RegisterRepositoryImpl>((ref) {
  return RegisterRepositoryImpl(SupabaseRemoteDatasource());
});


// =========================================================
// USECASE: DAFTAR AKUN (auth.users)
// =========================================================
final registerAccountProvider = Provider<RegisterAccount>((ref) {
  return RegisterAccount(ref.read(registerRepositoryProvider));
});


// =========================================================
// USECASE: Membuat keluarga + warga pertama
// =========================================================
final createKeluargaAndWargaProvider = Provider<CreateKeluargaAndWarga>((ref) {
  return CreateKeluargaAndWarga(ref.read(registerRepositoryProvider));
});


// =========================================================
// USECASE: Membuat rumah (data alamat keluarga)
// =========================================================
final createRumahProvider = Provider<CreateRumah>((ref) {
  return CreateRumah(ref.read(registerRepositoryProvider));
});


// =========================================================
// STATE untuk multi-step register
// Step 1 → data akun
// Step 2 → data warga + keluarga
// Step 3 → data rumah
// =========================================================
class RegisterState {
  final String? email;
  final String? password;
  final String? userId;

  final String? nama;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String roleKeluarga;

  final int? keluargaId;

  final String? blok;
  final String? nomorRumah;
  final String? alamatLengkap;

  RegisterState({
    this.email,
    this.password,
    this.userId,
    this.nama,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.roleKeluarga = 'kepala_keluarga',
    this.keluargaId,
    this.blok,
    this.nomorRumah,
    this.alamatLengkap,
  });

  // Copy state untuk update field tertentu saja
  RegisterState copyWith({
    String? email,
    String? password,
    String? userId,
    String? nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? roleKeluarga,
    int? keluargaId,
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      userId: userId ?? this.userId,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      roleKeluarga: roleKeluarga ?? this.roleKeluarga,
      keluargaId: keluargaId ?? this.keluargaId,
      blok: blok ?? this.blok,
      nomorRumah: nomorRumah ?? this.nomorRumah,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
    );
  }
}


// =========================================================
// PROVIDER untuk RegisterState
// Dipakai untuk menyimpan progress register multi-step
// =========================================================
final registerStateProvider = StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  return RegisterNotifier();
});


// =========================================================
// NOTIFIER untuk mengontrol perubahan RegisterState
// =========================================================
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  // ---------------------------
  // STEP 1: SIMPAN DATA AKUN
  // ---------------------------
  void updateAccount(String email, String password, String userId) {
    state = state.copyWith(email: email, password: password, userId: userId);
  }

  // ---------------------------
  // STEP 2: SIMPAN DATA WARGA + KELUARGA
  // ---------------------------
  void updateWarga(
      String nama,
      String? nik,
      String? jenisKelamin,
      DateTime? tanggalLahir,
      String roleKeluarga,
      int keluargaId,
  ) {
    state = state.copyWith(
      nama: nama,
      nik: nik,
      jenisKelamin: jenisKelamin,
      tanggalLahir: tanggalLahir,
      roleKeluarga: roleKeluarga,
      keluargaId: keluargaId,
    );
  }

  // ---------------------------
  // STEP 3: SIMPAN DATA RUMAH
  // ---------------------------
  void updateRumah(String? blok, String? nomorRumah, String? alamatLengkap) {
    state = state.copyWith(
      blok: blok,
      nomorRumah: nomorRumah,
      alamatLengkap: alamatLengkap,
    );
  }

  // Reset seluruh state (untuk ulang proses register)
  void reset() {
    state = RegisterState();
  }
}
