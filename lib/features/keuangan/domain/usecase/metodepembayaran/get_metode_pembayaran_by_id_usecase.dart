import '../../../data/models/metodepembayaran_model.dart';
import '../../repositories/metodepembayaran_repository.dart';

class GetMetodePembayaranUsecase {
  final MetodePembayaranRepository repository;
  GetMetodePembayaranUsecase(this.repository);
  Future<MetodePembayaran?> call(int id) async 
  => await repository.getMetodeById(id);
}