// lib/domain/usecases/create_keluarga_and_warga.dart

import '../repositories/register_repository.dart';

class CreateKeluargaAndWarga {
  final RegisterRepository repository;

  CreateKeluargaAndWarga(this.repository);

  Future<int> call({
    required String userId,
    required String nama,
    required String? nik,
    required String? jenisKelamin,
    required DateTime? tanggalLahir,
    required String roleKeluarga,
  }) async {
    // Kembalikan keluargaId sesuai RegisterRepository
    return repository.createKeluargaAndWarga(
      userId: userId,
      nama: nama,
      nik: nik,
      jenisKelamin: jenisKelamin,
      tanggalLahir: tanggalLahir,
      roleKeluarga: roleKeluarga,
    );
  }
}
