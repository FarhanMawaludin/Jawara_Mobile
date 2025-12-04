import '../../repositories/kategori_iuran_repository.dart';

class DeleteKategoriUsecase {
  final KategoriIuranRepository repository;

  DeleteKategoriUsecase(this.repository);

  Future<bool> call(int id) async {
    return await repository.deleteKategori(id);
  }
}