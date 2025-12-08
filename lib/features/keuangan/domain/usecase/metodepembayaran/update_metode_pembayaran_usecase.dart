import '../../../data/models/metodepembayaran_model.dart';
import '../../repositories/metodepembayaran_repository.dart';

class UpdateMetodePembayaranUsecase {
  final MetodePembayaranRepository repository;
  UpdateMetodePembayaranUsecase(this.repository);
  Future<bool> call(MetodePembayaran data) async => 
  await repository.updateMetode(data);
}