import '../../entities/pemasukanlainnya.dart';
import '../../repositories/pemasukanlainnya_repository.dart';

class UpdatePemasukanUsecase {
  final PemasukanLainnyaRepository repository;

  UpdatePemasukanUsecase(this.repository);

  Future<void> call(PemasukanLainnya data) async {
    return await repository.updatePemasukan(data);
  }
}
