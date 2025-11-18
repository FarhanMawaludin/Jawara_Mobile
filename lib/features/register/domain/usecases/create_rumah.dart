// lib/domain/usecases/create_rumah.dart
import '../entities/rumah.dart';
import '../repositories/register_repository.dart';

class CreateRumah {
  final RegisterRepository repository;

  CreateRumah(this.repository);

  Future<Rumah> execute(
    int keluargaId,
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  ) {
    return repository.createRumah(
      keluargaId,
      blok,
      nomorRumah,
      alamatLengkap,
    );
  }
}