// lib/domain/usecases/create_keluarga_and_warga.dart
import '../entities/keluarga.dart';
import '../entities/warga.dart';
import '../repositories/register_repository.dart';

class CreateKeluargaAndWarga {
  final RegisterRepository repository;

  CreateKeluargaAndWarga(this.repository);

  Future<(Keluarga, Warga)> execute(
    String userId,
    String namaKeluarga,
    String nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String roleKeluarga,
  ) {
    return repository.createKeluargaAndWarga(
      userId,
      namaKeluarga,
      nama,
      nik,
      jenisKelamin,
      tanggalLahir,
      roleKeluarga,
    );
  }
}