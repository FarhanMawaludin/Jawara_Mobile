import '../../../data/models/iurandetail_model.dart';
import '../../repositories/iurandetail_repository.dart';

class UpdateIuranDetail {
  final IuranDetailRepository repository;

  UpdateIuranDetail(this.repository);

  Future<bool> call(IuranDetail data) {
    return repository.update(data);
  }
}