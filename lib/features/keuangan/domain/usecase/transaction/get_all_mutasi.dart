import '../../entities/mutasi.dart';
import '../../repositories/mutasi_repository.dart';


class GetAllMutasi {
final MutasiRepository repository;

GetAllMutasi(this.repository);

Future<List<Mutasi>> call() async {
  return await repository.getAllMutasi();
  }
}