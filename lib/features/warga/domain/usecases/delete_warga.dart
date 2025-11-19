import '../repositories/warga_repository.dart';

class DeleteWarga {
  final WargaRepository repository;

  DeleteWarga(this.repository);

  Future<void> call(int id) async {
    await repository.deleteWarga(id);
  }
}
