import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';

abstract class KategoriIuranRepository {
  Future<List<KategoriIuran>> getAllKategori();
  Future<KategoriIuran?> getKategoriById(int id);
  Future<KategoriIuran?> createKategori(KategoriIuran data);
  Future<KategoriIuran?> updateKategori(int id, KategoriIuran data);
  Future<bool> deleteKategori(int id);
}
