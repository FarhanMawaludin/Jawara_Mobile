import '../entities/warga.dart';

abstract class WargaRepository {
  Future<List<Warga>> getAllWarga();
  Future<Warga?> getWargaById(int id);
  Future<void> createWarga(Warga warga);
  Future<void> updateWarga(Warga warga);
  Future<void> deleteWarga(int id);
  Future<List<Warga>> searchWarga(String keyword);
}
