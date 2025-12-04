import '../../repositories/metodepembayaran_repository.dart';

class DeleteMetodePembayaran {
  final MetodePembayaranRepository repository;
  DeleteMetodePembayaran(this.repository);
  Future<bool> call(int id) async => 
  await repository.deleteMetode(id);
}