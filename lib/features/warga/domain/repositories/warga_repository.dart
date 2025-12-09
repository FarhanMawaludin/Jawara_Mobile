import '../entities/warga.dart';
import '../entities/statistik.dart';

abstract class WargaRepository {
  Future<List<Warga>> getAllWarga();
  Future<List<Warga>> getAllKeluarga();
  Future<Warga?> getWargaById(int id);
  Future<void> createWarga(Warga warga);
  Future<void> updateWarga(Warga warga);
  Future<void> deleteWarga(int id);
  Future<List<Warga>> searchWarga(String keyword);
  Future<List<Warga>> getWargaByKeluargaId(int keluargaId);

  /// Menghasilkan statistik warga. Implementasi dapat memanggil RPC database
  /// atau menghitung client-side dari tabel `warga`.
  Future<StatistikWarga> getStatistikWarga();
  Future<List<Warga>> getWargaByKeluargaId(int keluargaId); 
  Future<int> countKeluarga();
  Future<int> countWarga();
}
