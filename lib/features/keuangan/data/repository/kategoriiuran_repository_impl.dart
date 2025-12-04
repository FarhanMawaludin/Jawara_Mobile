import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';
import '../datasources/kategoriiuran_remote_datasource.dart';
import '../../domain/repositories/kategori_iuran_repository.dart';



class KategoriIuranRepositoryImpl implements KategoriIuranRepository {
  final KategoriIuranDatasource datasource;

  KategoriIuranRepositoryImpl(this.datasource);

  @override
  Future<List<KategoriIuran>> getAllKategori() async {
    return await datasource.getAll();
  }

  @override
  Future<KategoriIuran?> getKategoriById(int id) async {
    return await datasource.getById(id);
  }

  @override
  Future<KategoriIuran?> createKategori(KategoriIuran data) async {
    return await datasource.create(data);
  }

  @override
  Future<KategoriIuran?> updateKategori(int id, KategoriIuran data) async {
    return await datasource.update(id, data);
  }

  @override
  Future<bool> deleteKategori(int id) async {
    return await datasource.delete(id);
  }
}
