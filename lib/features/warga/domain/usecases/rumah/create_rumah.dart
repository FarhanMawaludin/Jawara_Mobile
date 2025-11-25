import '../../entities/rumah.dart';
import '../../repositories/rumah_repository.dart';

class CreateRumah {
  final RumahRepository repository;

  CreateRumah(this.repository);

  Future<void> call(Rumah rumah) async {
    return await repository.createRumah(rumah);
  }
}

