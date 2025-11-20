import '../../entities/rumah.dart';
import '../../repositories/rumah_repository.dart';

class GetAllRumah {
  final RumahRepository repository;

  GetAllRumah(this.repository);

  Future<List<Rumah>> call() async {
    return await repository.getAllRumah();
  }
}
