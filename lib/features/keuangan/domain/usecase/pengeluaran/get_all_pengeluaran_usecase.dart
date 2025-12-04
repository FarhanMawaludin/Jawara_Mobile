import '../../entities/pengeluaran.dart';
import '../../repositories/pengeluaran_repository.dart';

class GetAllPengeluaranUsecase {
  final PengeluaranRepository repository;

  GetAllPengeluaranUsecase(this.repository);

  Future<List<Pengeluaran>> call() async {
    return await repository.getAllPengeluaran();
  }
}
