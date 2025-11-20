import '../../entities/rumah.dart';
import '../../repositories/rumah_repository.dart';

class UpdateRumah {
  final RumahRepository repository;

  UpdateRumah(this.repository);

  Future<void> call(Rumah rumah) async {
    return await repository.updateRumah(rumah);
  }
}
