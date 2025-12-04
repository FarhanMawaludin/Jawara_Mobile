import '../../../data/models/kategoriiuran_model.dart';
import '../../repositories/kategori_iuran_repository.dart';

class GetKategoriByIdUsecase {
  final KategoriIuranRepository repository;
  GetKategoriByIdUsecase(this.repository);

  Future<KategoriIuran?> call(int id) async {
    return await repository.getKategoriById(id);
  }
}