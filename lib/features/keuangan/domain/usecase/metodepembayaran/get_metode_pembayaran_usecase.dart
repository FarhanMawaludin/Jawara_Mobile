import '../../../data/models/metodepembayaran_model.dart';
import '../../repositories/metodepembayaran_repository.dart';

class GetMetodePembayaranUsecase {
  final MetodePembayaranRepository repository;
  GetMetodePembayaranUsecase(this.repository);
  Future<List<MetodePembayaran>> call() async 
  => await repository.getAllMetode();
}