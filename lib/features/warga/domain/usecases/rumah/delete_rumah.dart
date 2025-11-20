import '../../repositories/rumah_repository.dart';

class DeleteRumah {
  final RumahRepository repository;

  DeleteRumah(this.repository);

  Future<void> call(int id) async {
    return await repository.deleteRumah(id);
  }
}
