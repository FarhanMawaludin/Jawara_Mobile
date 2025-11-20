import '../../entities/warga.dart';
import '../../repositories/warga_repository.dart';

class UpdateWarga {
  final WargaRepository repository;

  UpdateWarga(this.repository);

  Future<void> call(Warga warga) async {
    await repository.updateWarga(warga);
  }
}
