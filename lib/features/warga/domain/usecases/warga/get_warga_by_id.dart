import '../../entities/warga.dart';
import '../../repositories/warga_repository.dart';

class GetWargaById {
  final WargaRepository repository;

  GetWargaById(this.repository);

  Future<Warga?> call(int id) async {
    return await repository.getWargaById(id);
  }
}
