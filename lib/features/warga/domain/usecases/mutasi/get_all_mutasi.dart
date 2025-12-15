import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';

class GetAllMutasi {
  final MutasiRepository repository;
  GetAllMutasi(this.repository);

  Future<List<Mutasi>> call() async {
    return await repository.getAllMutasi();
  }
}
