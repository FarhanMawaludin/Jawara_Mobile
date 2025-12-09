import '../../entities/tagihiuran.dart';
import '../../repositories/tagihiuran_repository.dart';

class GetTagihanByIdUsecase {
  final TagihIuranRepository repository;

  GetTagihanByIdUsecase(this.repository);

  Future<TagihIuran?> call(int id) async {
    return await repository.getTagihanById(id);
  }
}
