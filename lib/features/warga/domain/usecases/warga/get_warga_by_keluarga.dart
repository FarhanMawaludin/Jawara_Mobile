import '../../entities/warga.dart';
import '../../repositories/warga_repository.dart';

class GetWargaByKeluarga {
  final WargaRepository repository;
  GetWargaByKeluarga(this.repository);

  Future<List<Warga>> call(int keluargaId) {
    return repository.getWargaByKeluargaId(keluargaId);
  }
}
