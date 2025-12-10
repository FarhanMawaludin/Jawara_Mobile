import '../../domain/entities/tagihiuran.dart';

abstract class TagihIuranRepository {
  Future<List<TagihIuran>> getAllTagihan();
  Future<TagihIuran?> getTagihanById(int id);
  Future<bool> updateTagihan(int id, TagihIuran data);
  Future<bool> deleteTagihan(int id);
  Future<void> createTagihanForAllKeluarga({
    required int kategoriId,
    required String nama,
    required int jumlah,
  });
}
