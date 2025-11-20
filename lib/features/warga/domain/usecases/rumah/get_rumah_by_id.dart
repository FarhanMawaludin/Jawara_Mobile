import '../../entities/rumah.dart';
import '../../repositories/rumah_repository.dart';

class GetRumahById {
  final RumahRepository repository;

  GetRumahById(this.repository);

  Future<Rumah?> call(int id) async {
    return await repository.getRumahById(id);
  }
}
