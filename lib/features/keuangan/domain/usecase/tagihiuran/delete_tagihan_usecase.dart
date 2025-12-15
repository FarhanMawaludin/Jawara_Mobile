import '../../repositories/tagihiuran_repository.dart';

class DeleteTagihanUsecase {
  final TagihIuranRepository repository;

  DeleteTagihanUsecase(this.repository);

  Future<bool> call(int id) async {
    return await repository.deleteTagihan(id);
  }
}
