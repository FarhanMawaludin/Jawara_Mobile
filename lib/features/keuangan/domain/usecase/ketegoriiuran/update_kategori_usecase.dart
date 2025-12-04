import '../../../data/models/kategoriiuran_model.dart';
import '../../repositories/kategori_iuran_repository.dart';

class UpdateKategoriUsecase {
  final KategoriIuranRepository repository;

  UpdateKategoriUsecase(this.repository);

  Future<KategoriIuran?> call(int id, KategoriIuran data) async {
    return await repository.updateKategori(id, data);
  }
}