import '../../../data/models/metodepembayaran_model.dart';
import '../../repositories/metodepembayaran_repository.dart';

class CreateMetodePembayaranUsecase {
  final MetodePembayaranRepository repository;
  CreateMetodePembayaranUsecase(this.repository);
  Future<void> call(MetodePembayaranModel data) async 
    => await repository.createMetode(data);
}