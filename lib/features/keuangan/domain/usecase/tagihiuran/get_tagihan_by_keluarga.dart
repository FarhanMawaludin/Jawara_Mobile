import '../../entities/tagihiuran.dart';
import '../../repositories/tagihiuran_repository.dart';

class GetTagihanByKeluargaUsecase {
  final TagihIuranRepository repository;

  GetTagihanByKeluargaUsecase(this.repository);

  Future<List<TagihIuran>> call(int keluargaId) async {
    return await repository.getTagihanByKeluarga(keluargaId);
  }
}
