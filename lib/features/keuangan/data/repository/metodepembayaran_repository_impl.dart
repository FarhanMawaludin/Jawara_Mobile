import '../../domain/repositories/metodepembayaran_repository.dart';
import '../datasources/metode_pembayaran_remote_datasource.dart';
import '../models/metodepembayaran_model.dart';

class MetodePembayaranRepositoryImpl implements MetodePembayaranRepository {
  final MetodePembayaranDatasource datasource;

  MetodePembayaranRepositoryImpl(this.datasource);

  @override
  Future<List<MetodePembayaran>> getAllMetode() {
    return datasource.getAll();
  }

  @override
  Future<MetodePembayaran?> getMetodeById(int id) {
    return datasource.getById(id);
  }

  @override
  Future<bool> createMetode(MetodePembayaran data) async {
    return datasource.insert(data);
  }

  @override
  Future<bool> updateMetode(MetodePembayaran data) {
    return datasource.update(data);
  }

  @override
  Future<bool> deleteMetode(int id) {
    return datasource.delete(id);
  }
}
