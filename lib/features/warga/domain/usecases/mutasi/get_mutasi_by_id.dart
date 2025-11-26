import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';

class GetMutasiById {
  final MutasiRepository repository;

  GetMutasiById(this.repository);

  Future<Mutasi?> call(int id) async {
    return await repository.getMutasiById(id);
  }
}
