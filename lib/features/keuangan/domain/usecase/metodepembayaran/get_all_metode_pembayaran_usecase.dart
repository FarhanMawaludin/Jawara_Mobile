import '../../../data/models/metodepembayaran_model.dart';
import '../../repositories/metodepembayaran_repository.dart';

class GetAllMetodePembayaranUsecase {
  final MetodePembayaranRepository repository;
  GetAllMetodePembayaranUsecase(this.repository);
  Future<List<MetodePembayaranModel>> call() async 
  => await repository.getAllMetode();
}