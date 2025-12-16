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
  Future<bool> updateTagihan(int id, TagihIuran data) async {
    return await datasource.update(id, data as TagihIuranModel);
  }

  @override
  Future<bool> deleteTagihan(int id) async {
    return await datasource. delete(id);
  }

  @override
  Future<void> createTagihanForAllKeluarga({
    required int kategoriId,
    required String nama,
    required int jumlah,
  }) async {
    try {
      // 1. Insert ke tagih_iuran
      final tagihResponse = await datasource.insert({
        'kategori_id': kategoriId,
        'jumlah': jumlah.toDouble(),
        'tanggal_tagihan': DateTime.now().toIso8601String().split('T')[0], // ✅ YYYY-MM-DD
        'nama':  nama,
        'status_tagihan': 'belum bayar',
      });

      print('✅ Tagih Iuran Created: $tagihResponse');

      final tagihId = tagihResponse['id'] as int;

      // 2. Ambil semua keluarga IDs
      final keluargaIds = await datasource. getAllKeluargaIds();
      print('✅ Total Keluarga:  ${keluargaIds.length}');

      if (keluargaIds.isEmpty) {
        throw Exception('Tidak ada data keluarga');
      }

      // 3. Buat data untuk iuran_detail
      final iuranDetailList = keluargaIds.map((keluargaId) => {
        'keluarga_id': keluargaId,
        'tagih_iuran': tagihId, // ✅ Foreign key ke tagih_iuran. id
        'metode_pembayaran_id': null, // ✅ Null karena belum bayar
      }).toList();

      print('✅ Iuran Detail to Insert: ${iuranDetailList.length} records');

      // 4. Bulk insert ke iuran_detail
      await datasource.bulkInsertIuranDetail(iuranDetailList);

      print('✅ Bulk Insert Success! ');
    } catch (e, stackTrace) {
      print('❌ Error createTagihanForAllKeluarga: $e');
      print('📍 StackTrace: $stackTrace');
      rethrow;
    }
  }
}