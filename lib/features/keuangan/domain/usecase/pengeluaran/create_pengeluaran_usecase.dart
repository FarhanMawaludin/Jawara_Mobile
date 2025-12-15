import '../../entities/pengeluaran.dart';
import '../../repositories/pengeluaran_repository.dart';

class CreatePengeluaranUsecase {
  final PengeluaranRepository repository;

  CreatePengeluaranUsecase(this.repository);

  Future<void> call(Pengeluaran data) async {
    await repository.createPengeluaran(data);
  }
}
