import '../datasources/pemasukanlainnya_remote_datasource.dart';
import '../../domain/repositories/pemasukanlainnya_repository.dart';
import '../models/pemasukanlainnya_model.dart';

class PemasukanLainnyaRepositoryImpl
    implements PemasukanLainnyaRepository {
  final PemasukanLainnyaDatasource datasource;

  PemasukanLainnyaRepositoryImpl(this.datasource);

  @override
  Future<List<PemasukanLainnya>> getAllPemasukan() async {
    return await datasource.getAll();
  }

  @override
  Future<PemasukanLainnya?> getPemasukanById(int id) async {
    return await datasource.getById(id);
  }

  @override
  Future<void> createPemasukan(PemasukanLainnya data) async {
    return await datasource.insert(data);
  }

  @override
  Future<void> updatePemasukan(PemasukanLainnya data) async {
    return await datasource.update(data);
  }

  @override
  Future<void> deletePemasukan(int id) async {
    return await datasource.delete(id);
  }
}
