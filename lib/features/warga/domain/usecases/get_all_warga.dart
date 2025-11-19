import '../entities/warga.dart';
import '../repositories/warga_repository.dart';

class GetAllWarga {
  final WargaRepository repository;

  GetAllWarga(this.repository);

  Future<List<Warga>> call() async {
    return await repository.getAllWarga();
  }
}
