import '../models/iurandetail_model.dart';
import '../../domain/repositories/iurandetail_repository.dart';
import '../datasources/iurandetail_remote_datasource.dart';

class IuranDetailRepositoryImpl implements IuranDetailRepository {
  final IuranDetailDatasource datasource;

  IuranDetailRepositoryImpl({required this.datasource});

  @override
  Future<List<IuranDetail>> getByKeluarga(int keluargaId) {
    return datasource.getByKeluarga(keluargaId);
  }

  @override
  Future<bool> create(IuranDetail data) async {
    await datasource.insert(data);
    return true;
  }

  @override
  Future<bool> update(IuranDetail data) async {
    await datasource.update(data);
    return true;
  }

  @override
  Future<bool> delete(int id) async {
    await datasource.delete(id);
    return true;
  }
}
