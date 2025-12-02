import '../entities/pemasukanlainnya.dart';

abstract class PemasukanLainnyaRepository {
  Future<List<PemasukanLainnya>> getAllPemasukan();
  Future<PemasukanLainnya?> getPemasukanById(int id);
  Future<void> createPemasukan(PemasukanLainnya data);
  Future<void> updatePemasukan(PemasukanLainnya data);
  Future<void> deletePemasukan(int id);
}
