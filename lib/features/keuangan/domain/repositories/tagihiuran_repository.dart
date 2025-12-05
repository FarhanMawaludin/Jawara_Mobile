import '../../domain/entities/tagihiuran.dart';

abstract class TagihIuranRepository {
  Future<List<TagihIuran>> getAllTagihan();
  Future<TagihIuran?> getTagihanById(int id);
  Future<List<TagihIuran>> getTagihanByKeluarga(int keluargaId);
  Future<bool> createTagihan(TagihIuran data);
  Future<bool> updateTagihan(int id, TagihIuran data);
  Future<bool> deleteTagihan(int id);
}
