import '../../../data/models/kategoriiuran_model.dart';
import '../../repositories/kategori_iuran_repository.dart';

class GetAllKategoriUsecase {
  final KategoriIuranRepository repository;
  GetAllKategoriUsecase(this.repository);

  Future<List<KategoriIuran>> call() async {
    return await repository.getAllKategori();
  }
}