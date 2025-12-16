import '../../entities/pemasukanlainnya.dart';
import '../../repositories/pemasukanlainnya_repository.dart';

class GetPemasukanByIdUsecase {
  final PemasukanLainnyaRepository repository;

  GetPemasukanByIdUsecase(this.repository);

  Future<PemasukanLainnya?> call(int id) {
    return repository.getPemasukanById(id);
  }
}
