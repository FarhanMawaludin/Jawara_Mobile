import '../../entities/tagihiuran.dart';
import '../../repositories/tagihiuran_repository.dart';

class GetAllTagihanUsecase {
  final TagihIuranRepository repository;

  GetAllTagihanUsecase(this.repository);

  Future<List<TagihIuran>> call() async {
    return await repository.getAllTagihan();
  }
}
