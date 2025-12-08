import '../../entities/pengeluaran.dart';
import '../../repositories/pengeluaran_repository.dart';

class UpdatePengeluaranUsecase {
  final PengeluaranRepository repository;

  UpdatePengeluaranUsecase(this.repository);

  Future<void> call(Pengeluaran data) async {
    await repository.updatePengeluaran(data);
  }
}
