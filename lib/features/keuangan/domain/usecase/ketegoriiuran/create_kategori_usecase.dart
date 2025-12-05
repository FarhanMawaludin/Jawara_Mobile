import '../../../data/models/kategoriiuran_model.dart';
import '../../repositories/kategori_iuran_repository.dart';

class CreateKategoriUsecase {
  final KategoriIuranRepository repository;

  CreateKategoriUsecase(this.repository);

  Future<KategoriIuran?> call(KategoriIuran data) async {
    return await repository.createKategori(data);
  }
}