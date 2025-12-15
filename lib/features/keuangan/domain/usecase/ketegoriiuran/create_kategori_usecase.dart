import '../../../data/models/kategoriiuran_model.dart';
import '../../repositories/kategori_iuran_repository.dart';

class CreateKategoriUsecase {
  final KategoriIuranRepository repository;

  CreateKategoriUsecase(this.repository);

  Future<KategoriIuranModel?> call(KategoriIuranModel data) async {
    return await repository.createKategori(data);
  }
}