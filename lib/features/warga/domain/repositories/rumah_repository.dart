import 'package:jawaramobile/features/warga/data/models/rumah_model.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';

abstract class RumahRepository {
  Future<List<Rumah>> getAllRumah();
  Future<RumahModel?> getRumahById(int id);
  Future<List<Rumah>> getRumahByKeluarga(int keluargaId);
  Future<void> createRumah(Rumah rumah);
  Future<void> updateRumah(Rumah rumah);
  Future<void> deleteRumah(int id);
  Future<List<Rumah>> searchRumah(String keyword);
}
