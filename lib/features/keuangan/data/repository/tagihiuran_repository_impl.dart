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
    return await datasource.delete(id);
  }

  @override
  Future<void> createTagihanForAllKeluarga({
    required int kategoriId,
    required String nama,
    required int jumlah,
  }) async {
    // 1. Insert tagih_iuran
    final tagihResponse = await datasource.insert({
      'kategori_id': kategoriId,
      'jumlah': jumlah,
      'tanggal_tagihan': DateTime.now().toIso8601String().split('T')[0],
      'nama': nama,
      'status_tagihan': 'belum bayar',
    });

    final tagihId = tagihResponse['id'];

    // 2. Ambil semua keluarga IDs
    final keluargaIds = await datasource.getAllKeluargaIds(); 

    // 3. Buat data untuk iuran_detail
    final iuranDetailList = keluargaIds.map((keluargaId) => {
      'keluarga_id': keluargaId,
      'tagih_iuran': tagihId,
      'metode_pembayaran_id': null, // ✅ Set null (belum ada metode pembayaran)
    }).toList();

    // 4. Bulk insert ke iuran_detail
    if (iuranDetailList.isNotEmpty) {
      await datasource.bulkInsertIuranDetail(iuranDetailList);
    }
  }
}