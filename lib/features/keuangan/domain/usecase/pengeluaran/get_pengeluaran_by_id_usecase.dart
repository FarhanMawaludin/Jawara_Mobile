import '../../entities/pengeluaran.dart';
import '../../repositories/pengeluaran_repository.dart';

class GetPengeluaranByIdUsecase {
  final PengeluaranRepository repository;

  GetPengeluaranByIdUsecase(this.repository);

  Future<Pengeluaran?> call(int id) async {
    return await repository.getPengeluaranById(id);
  }
}
