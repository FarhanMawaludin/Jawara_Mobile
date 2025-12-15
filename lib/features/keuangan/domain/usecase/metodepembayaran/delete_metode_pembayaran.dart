import '../../repositories/metodepembayaran_repository.dart';

class DeleteMetodePembayaran {
  final MetodePembayaranRepository repository;
  DeleteMetodePembayaran(this.repository);
  Future<void> call(int id) async => 
  await repository.deleteMetode(id);
}