import '../../repositories/pemasukanlainnya_repository.dart';

class DeletePemasukanUsecase {
  final PemasukanLainnyaRepository repository;

  DeletePemasukanUsecase(this.repository);

  Future<void> call(int id) async {
    return await repository.deletePemasukan(id);
  }
}
