import '../../entities/pemasukanlainnya.dart';
import '../../repositories/pemasukanlainnya_repository.dart';

class CreatePemasukanUsecase {
  final PemasukanLainnyaRepository repository;

  CreatePemasukanUsecase(this.repository);

  Future<void> call(PemasukanLainnya data) async {
    return await repository.createPemasukan(data);
  }
}
