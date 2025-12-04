import '../../repositories/iurandetail_repository.dart';

class DeleteIuranDetail {
  final IuranDetailRepository repository;

  DeleteIuranDetail(this.repository);

  Future<bool> call(int id) {
    return repository.delete(id);
  }
}