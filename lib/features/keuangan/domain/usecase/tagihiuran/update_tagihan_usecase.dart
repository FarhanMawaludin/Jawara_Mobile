import '../../entities/tagihiuran.dart';
import '../../repositories/tagihiuran_repository.dart';

class UpdateTagihanUsecase {
  final TagihIuranRepository repository;

  UpdateTagihanUsecase(this.repository);

  Future<bool> call(int id, TagihIuran data) async {
    return await repository.updateTagihan(id, data);
  }
}
