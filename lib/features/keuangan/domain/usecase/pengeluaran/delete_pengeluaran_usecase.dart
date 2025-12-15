import '../../repositories/pengeluaran_repository.dart';

class DeletePengeluaranUsecase {
  final PengeluaranRepository repository;

  DeletePengeluaranUsecase(this.repository);

  Future<void> call(int id) async {
    await repository.deletePengeluaran(id);
  }
}
