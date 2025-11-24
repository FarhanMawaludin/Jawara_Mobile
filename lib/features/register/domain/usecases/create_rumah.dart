// lib/domain/usecases/create_rumah.dart

import '../repositories/register_repository.dart';

class CreateRumah {
  final RegisterRepository repository;

  CreateRumah(this.repository);

  Future<int> call({
    required int keluargaId,
    required String? blok,
    required String? nomorRumah,
    required String? alamatLengkap,
  }) async {
    return repository.createRumah(
      keluargaId: keluargaId,
      blok: blok,
      nomorRumah: nomorRumah,
      alamatLengkap: alamatLengkap,
    );
  }
}
