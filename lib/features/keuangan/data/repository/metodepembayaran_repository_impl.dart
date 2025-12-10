import '../../domain/repositories/metodepembayaran_repository.dart';
import '../datasources/metode_pembayaran_remote_datasource.dart';
import '../models/metodepembayaran_model.dart';

class MetodePembayaranRepositoryImpl implements MetodePembayaranRepository {
  final MetodePembayaranDatasource datasource;

  MetodePembayaranRepositoryImpl(this.datasource);

  @override
  Future<List<MetodePembayaranModel>> getAllMetode() {
    return datasource.getAll();
  }

  @override
  Future<MetodePembayaranModel?> getMetodeById(int id) {
    return datasource.getById(id);
  }

  @override
  Future<void> createMetode(MetodePembayaranModel data) {
    return datasource.create(data);
  }

  @override
  Future<void> updateMetode(MetodePembayaranModel data) {
    return datasource.update(data);
  }

  @override
  Future<void> deleteMetode(int id) {
    return datasource.delete(id);
  }
}
