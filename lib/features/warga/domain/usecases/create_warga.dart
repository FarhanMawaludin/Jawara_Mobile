import '../entities/warga.dart';
import '../repositories/warga_repository.dart';

class CreateWarga {
  final WargaRepository repository;

  CreateWarga(this.repository);

  Future<void> call(Warga warga) async {
    await repository.createWarga(warga);
  }
}
