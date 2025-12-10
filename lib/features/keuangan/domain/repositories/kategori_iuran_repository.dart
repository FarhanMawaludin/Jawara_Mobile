import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';

abstract class KategoriIuranRepository {
  Future<List<KategoriIuranModel>> getAllKategori();
  Future<KategoriIuranModel?> getKategoriById(int id);
  Future<KategoriIuranModel?> createKategori(KategoriIuranModel data);
  Future<KategoriIuranModel?> updateKategori(int id, KategoriIuranModel data);
  Future<bool> deleteKategori(int id);
}
