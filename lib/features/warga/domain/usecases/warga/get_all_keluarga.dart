import '../../entities/warga.dart';
import '../../repositories/warga_repository.dart';

class GetAllKeluarga {
  final WargaRepository repository;

  GetAllKeluarga(this.repository);

  Future<List<Warga>> call() async {
    return await repository.getAllKeluarga();
  }
}
