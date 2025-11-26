// lib/data/repositories/register_repository_impl.dart

import '../../domain/repositories/register_repository.dart';
import '../datasources/supabase_remote_datasource.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final SupabaseRemoteDatasource datasource;

  RegisterRepositoryImpl(this.datasource);

  // ------------------------------------------------------
  // STEP 1 — Register Account
  // Return: userId (String)
  // ------------------------------------------------------
  @override
  Future<String> registerAccount(String email, String password) async {
    // datasource sudah return String userId
    final userId = await datasource.registerAccount(email, password);
    return userId;
  }

  // ------------------------------------------------------
  // STEP 2 — Create Keluarga & Warga
  // Return: keluargaId (int)
  // ------------------------------------------------------
  @override
  Future<int> createKeluargaAndWarga({
    required String userId,
    required String nama,
    required String? nik,
    required String? jenisKelamin,
    required DateTime? tanggalLahir,
    required String roleKeluarga,
  }) async {
    // datasource sudah return int keluargaId
    final keluargaId = await datasource.createKeluargaAndWarga(
      userId: userId,
      nama: nama,
      nik: nik,
      jenisKelamin: jenisKelamin,
      tanggalLahir: tanggalLahir,
      roleKeluarga: roleKeluarga,
    );

    return keluargaId;
  }

  // ------------------------------------------------------
  // STEP 3 — Create Rumah
  // Return: rumahId (int)
  // ------------------------------------------------------
  @override
  Future<int> createRumah({
    required int keluargaId,
    required String? blok,
    required String? nomorRumah,
    required String? alamatLengkap,
  }) async {
    // datasource sudah return rumahId
    final rumahId = await datasource.createRumah(
      keluargaId: keluargaId,
      blok: blok,
      nomorRumah: nomorRumah,
      alamatLengkap: alamatLengkap,
    );

    return rumahId;
  }
}
