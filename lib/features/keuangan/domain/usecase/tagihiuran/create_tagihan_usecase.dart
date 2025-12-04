import '../../entities/tagihiuran.dart';
import '../../repositories/tagihiuran_repository.dart';

class CreateTagihanUsecase {
  final TagihIuranRepository repository;

  CreateTagihanUsecase(this.repository);

  Future<bool> call(TagihIuran data) async {
    return await repository.createTagihan(data);
  }
}
