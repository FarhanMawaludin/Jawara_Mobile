import '../../../data/models/metodepembayaran_model.dart';
import '../../repositories/metodepembayaran_repository.dart';

class GetMetodePembayaranByIdUsecase {
  final MetodePembayaranRepository repository;
  GetMetodePembayaranByIdUsecase(this.repository);
  Future<MetodePembayaranModel?> call(int id) async 
  => await repository.getMetodeById(id);
}