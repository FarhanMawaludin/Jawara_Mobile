// lib/presentation/providers/register_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/warga/presentations/providers/mutasi/mutasi_providers.dart';

import '../../../warga/domain/entities/rumah.dart';
import '../../domain/usecases/register_account.dart';
import '../../domain/usecases/create_keluarga_and_warga.dart';
import '../../domain/usecases/create_rumah.dart';

import '../../data/repositories/register_repository_impl.dart';
import '../../data/datasources/supabase_remote_datasource.dart';

// =========================================================
// REPOSITORY PROVIDER
// =========================================================
final registerRepositoryProvider = Provider<RegisterRepositoryImpl>((ref) {
  return RegisterRepositoryImpl(SupabaseRemoteDatasource());
});

// =========================================================
// USECASE PROVIDERS
// =========================================================
final registerAccountProvider = Provider<RegisterAccount>((ref) {
  return RegisterAccount(ref.read(registerRepositoryProvider));
});

final createKeluargaAndWargaProvider = Provider<CreateKeluargaAndWarga>((ref) {
  return CreateKeluargaAndWarga(ref.read(registerRepositoryProvider));
});

final createRumahProvider = Provider<CreateRumah>((ref) {
  return CreateRumah(ref.read(registerRepositoryProvider));
});

final registerCheckEmailProvider =
    FutureProvider.family<bool, String>((ref, email) async {
  final supabase = ref.read(supabaseClientProvider);

  final result = await supabase.rpc(
    'check_email_exists',
    params: {'email_input': email},
  );

  return result == true;
});
// =========================================================
// STATE FINAL (AKAN DIKIRIM KE SERVER DI STEP 3)
// =========================================================
class RegisterState {
  final String? email;
  final String? password;

  final String? nama;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String roleKeluarga;

  final String? blok;
  final String? nomorRumah;
  final String? alamatLengkap;

  RegisterState({
    this.email,
    this.password,
    this.nama,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.roleKeluarga = 'kepala_keluarga',
    this.blok,
    this.nomorRumah,
    this.alamatLengkap,
  });

  RegisterState copyWith({
    String? email,
    String? password,
    String? nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String? roleKeluarga,
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  }) {
    return RegisterState(
      email: email ?? this.email,
      password: password ?? this.password,
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
      roleKeluarga: roleKeluarga ?? this.roleKeluarga,
      blok: blok ?? this.blok,
      nomorRumah: nomorRumah ?? this.nomorRumah,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
    );
  }
}

// =========================================================
// NOTIFIER: FINAL REGISTER PROCESS
// =========================================================
class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier() : super(RegisterState());

  // Menggabungkan semua cache ke RegisterState final
  void collectAllFromCache(WidgetRef ref) {
    final step1 = ref.read(registerStep1CacheProvider);
    final step2 = ref.read(registerStep2CacheProvider);
    final step3 = ref.read(registerStep3CacheProvider);

    state = state.copyWith(
      email: step1.email,
      password: step1.password,

      nama: step2.nama,
      nik: step2.nik,
      jenisKelamin: step2.jenisKelamin,
      tanggalLahir: step2.tanggalLahir,
      roleKeluarga: 'kepala_keluarga',

      blok: step3.blok,
      nomorRumah: step3.nomorRumah,
      alamatLengkap: step3.alamatLengkap,
    );
  }

  // 🚀 STEP 3: Submit semua data ke Supabase
  // Future<void> submitAll(WidgetRef ref) async {
  //   // Satukan cache → state final
  //   collectAllFromCache(ref);

  //   final accountUC = ref.read(registerAccountProvider);
  //   final keluargaUC = ref.read(createKeluargaAndWargaProvider);
  //   final rumahUC = ref.read(createRumahProvider);

  //   // 1. Register akun
  //   final userId = await accountUC.call(
  //     state.email!,
  //     state.password!,
  //   );

  //   // 2. Insert keluarga + warga pertama
  //   final keluargaId = await keluargaUC.call(
  //     nama: state.nama!,
  //     nik: state.nik!,
  //     jenisKelamin: state.jenisKelamin!,
  //     tanggalLahir: state.tanggalLahir!,
  //     roleKeluarga: state.roleKeluarga,
  //     userId: userId!,
  //   );

  //   // 3. Insert rumah
  //   await rumahUC.call(
  //     keluargaId: keluargaId,
  //     blok: state.blok!,
  //     nomorRumah: state.nomorRumah!,
  //     alamatLengkap: state.alamatLengkap!,
  //   );

  //   // Bersihkan setelah sukses
  //   reset();
  // }

  Future<int> submitAll(WidgetRef ref, {Rumah? selectedRumah}) async {
    // Satukan semua cache ke state final
    collectAllFromCache(ref);

    final accountUC = ref.read(registerAccountProvider);
    final keluargaUC = ref.read(createKeluargaAndWargaProvider);
    final rumahUC = ref.read(createRumahProvider);
    final updateRumahUC = ref.read(updateKeluargaRumahProvider);

    // 1. Register akun → dapat userId
    final userId = await accountUC.call(state.email!, state.password!);

    // 2. Insert keluarga + warga pertama
    final keluargaId = await keluargaUC.call(
      nama: state.nama!,
      nik: state.nik!,
      jenisKelamin: state.jenisKelamin!,
      tanggalLahir: state.tanggalLahir!,
      roleKeluarga: state.roleKeluarga,
      userId: userId!,
    );

    // ================================
    // 3. LOGIC RUMAH
    // ================================

    if (selectedRumah == null) {
      // -----------------------------------------------------
      // INPUT MANUAL → CREATE rumah baru
      // -----------------------------------------------------
      await rumahUC.call(
        keluargaId: keluargaId,
        blok: state.blok!,
        nomorRumah: state.nomorRumah!,
        alamatLengkap: state.alamatLengkap!,
      );
    } else {
      // -----------------------------------------------------
      // DROPDOWN DIPILIH → UPDATE rumah existing
      // tidak create baru
      // -----------------------------------------------------
      await updateRumahUC(keluargaId, selectedRumah.id!);
    }

    // Bersihkan cache
    reset();

    return keluargaId;
  }

  void reset() {
    state = RegisterState();
  }
}

// Provider final register state
final registerStateProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
      return RegisterNotifier();
    });

// =========================================================
// ============= CACHE: STEP 1 (email & password) ===========
// =========================================================

class RegisterStep1Cache {
  final String email;
  final String password;
  final String confirmPassword;

  RegisterStep1Cache({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
  });

  RegisterStep1Cache copyWith({
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    return RegisterStep1Cache(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
    );
  }
}

class RegisterStep1CacheNotifier extends StateNotifier<RegisterStep1Cache> {
  RegisterStep1CacheNotifier() : super(RegisterStep1Cache());

  void updateCache({String? email, String? password, String? confirmPassword}) {
    state = state.copyWith(
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  void clearCache() => state = RegisterStep1Cache();
}

final registerStep1CacheProvider =
    StateNotifierProvider<RegisterStep1CacheNotifier, RegisterStep1Cache>((
      ref,
    ) {
      return RegisterStep1CacheNotifier();
    });

// =========================================================
// ============= CACHE: STEP 2 (data warga) =================
// =========================================================

class RegisterStep2Cache {
  final String nama;
  final String nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;

  RegisterStep2Cache({
    this.nama = '',
    this.nik = '',
    this.jenisKelamin,
    this.tanggalLahir,
  });

  RegisterStep2Cache copyWith({
    String? nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
  }) {
    return RegisterStep2Cache(
      nama: nama ?? this.nama,
      nik: nik ?? this.nik,
      jenisKelamin: jenisKelamin ?? this.jenisKelamin,
      tanggalLahir: tanggalLahir ?? this.tanggalLahir,
    );
  }
}

class RegisterStep2CacheNotifier extends StateNotifier<RegisterStep2Cache> {
  RegisterStep2CacheNotifier() : super(RegisterStep2Cache());

  void updateCache({
    String? nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
  }) {
    state = state.copyWith(
      nama: nama,
      nik: nik,
      jenisKelamin: jenisKelamin,
      tanggalLahir: tanggalLahir,
    );
  }

  void clearCache() => state = RegisterStep2Cache();
}

final registerStep2CacheProvider =
    StateNotifierProvider<RegisterStep2CacheNotifier, RegisterStep2Cache>((
      ref,
    ) {
      return RegisterStep2CacheNotifier();
    });

// =========================================================
// ============= CACHE: STEP 3 (data rumah) =================
// =========================================================

class RegisterStep3Cache {
  final String blok;
  final String nomorRumah;
  final String alamatLengkap;

  RegisterStep3Cache({
    this.blok = '',
    this.nomorRumah = '',
    this.alamatLengkap = '',
  });

  RegisterStep3Cache copyWith({
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  }) {
    return RegisterStep3Cache(
      blok: blok ?? this.blok,
      nomorRumah: nomorRumah ?? this.nomorRumah,
      alamatLengkap: alamatLengkap ?? this.alamatLengkap,
    );
  }
}

class RegisterStep3CacheNotifier extends StateNotifier<RegisterStep3Cache> {
  RegisterStep3CacheNotifier() : super(RegisterStep3Cache());

  void updateCache({String? blok, String? nomorRumah, String? alamatLengkap}) {
    state = state.copyWith(
      blok: blok,
      nomorRumah: nomorRumah,
      alamatLengkap: alamatLengkap,
    );
  }

  void clearCache() => state = RegisterStep3Cache();
}

final registerStep3CacheProvider =
    StateNotifierProvider<RegisterStep3CacheNotifier, RegisterStep3Cache>((
      ref,
    ) {
      return RegisterStep3CacheNotifier();
    });
