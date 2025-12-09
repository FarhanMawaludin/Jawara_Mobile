
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';

abstract class MutasiRepository {
  Future<List<Mutasi>> getAllMutasi();
  Future<Mutasi?> getMutasiByKeluarga(int keluargaId);
  Future<Mutasi?> getMutasiById(int id);
  Future<void> createMutasi(Mutasi mutasi);
  Future<List<Mutasi>> searchMutasi(String keyword);
  Future<void> updateRumah(int keluargaId, int? rumahId);
}
