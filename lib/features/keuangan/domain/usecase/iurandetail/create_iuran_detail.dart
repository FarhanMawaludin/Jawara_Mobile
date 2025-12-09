
import '../../../data/models/iurandetail_model.dart';
import '../../repositories/iurandetail_repository.dart';

class CreateIuranDetail {
  final IuranDetailRepository repository;

  CreateIuranDetail(this.repository);

  Future<bool> call(IuranDetail data) {
    return repository.create(data);
  }
}