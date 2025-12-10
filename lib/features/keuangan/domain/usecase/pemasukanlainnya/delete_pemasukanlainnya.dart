import '../../repositories/pemasukanlainnya_repository.dart';

class DeletePemasukanLainnyaUsecase {
  final PemasukanLainnyaRepository repository;

  DeletePemasukanLainnyaUsecase(this.repository);

  Future<void> call(int id) async {
    return await repository.deletePemasukan(id);
  }
}
