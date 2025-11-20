import '../../entities/rumah.dart';
import '../../repositories/rumah_repository.dart';

class GetRumahByKeluarga {
  final RumahRepository repository;

  GetRumahByKeluarga(this.repository);

  Future<List<Rumah>> call(int keluargaId) async {
    return await repository.getRumahByKeluarga(keluargaId);
  }
}
