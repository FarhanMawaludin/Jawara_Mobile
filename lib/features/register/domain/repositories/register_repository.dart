// lib/domain/repositories/register_repository.dart

abstract class RegisterRepository {
  // STEP 1: daftar akun → return userId
  Future<String> registerAccount(String email, String password);

  // STEP 2: buat keluarga & warga → return keluargaId
  Future<int> createKeluargaAndWarga({
    required String userId,
    required String nama,
    required String? nik,
    required String? jenisKelamin,
    required DateTime? tanggalLahir,
    required String roleKeluarga,
  });

  // STEP 3: buat rumah → return rumahId (opsional)
  Future<int> createRumah({
    required int keluargaId,
    required String? blok,
    required String? nomorRumah,
    required String? alamatLengkap,
  });
}
