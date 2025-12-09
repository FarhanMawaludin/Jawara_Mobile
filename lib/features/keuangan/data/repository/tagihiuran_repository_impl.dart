import '../../domain/entities/tagihiuran.dart';
import '../../domain/repositories/tagihiuran_repository.dart';
import '../datasources/tagihiuran_remote_datasource.dart';
import '../models/tagihiuran_model.dart';

class TagihIuranRepositoryImpl implements TagihIuranRepository {
  final TagihIuranRemoteDatasource datasource;

  TagihIuranRepositoryImpl(this.datasource);

  @override
  Future<List<TagihIuran>> getAllTagihan() async {
    return await datasource.getAll();
  }

  @override
  Future<TagihIuran?> getTagihanById(int id) async {
    return await datasource.getById(id);
  }

  @override
  Future<List<TagihIuran>> getTagihanByKeluarga(int keluargaId) async {
    return await datasource.getByKeluarga(keluargaId);
  }

  @override
  Future<bool> createTagihan(TagihIuran data) async {
    return await datasource.create(data as TagihIuranModel);
  }

  @override
  Future<bool> updateTagihan(int id, TagihIuran data) async {
    return await datasource.update(id, data as TagihIuranModel);
  }

  @override
  Future<bool> deleteTagihan(int id) async {
    return await datasource.delete(id);
  }
}
