import '../../domain/entities/rumah.dart';
import '../../domain/repositories/rumah_repository.dart';
import '../datasources/rumah_remote_datasource.dart';
import '../models/rumah_model.dart';

class RumahRepositoryImpl implements RumahRepository {
  final RumahRemoteDataSource remoteDataSource;

  RumahRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Rumah>> getAllRumah() async {
    try {
      return await remoteDataSource.getAllRumah();
    } catch (e) {
      throw Exception("Gagal mengambil semua data Rumah: $e");
    }
  }

  @override
  Future<Rumah?> getRumahById(int id) async {
    try {
      return await remoteDataSource.getRumahById(id);
    } catch (e) {
      throw Exception("Gagal mengambil detail Rumah: $e");
    }
  }

  @override
  Future<List<Rumah>> getRumahByKeluarga(int keluargaId) async {
    try {
      final result = await remoteDataSource.getRumahByKeluarga(keluargaId);
      return result; // otomatis List<RumahModel> → List<Rumah>
    } catch (e) {
      throw Exception("Gagal mengambil Rumah berdasarkan keluarga_id: $e");
    }
  }

  @override
  Future<void> createRumah(Rumah rumah) async {
    try {
      final model = RumahModel(
        id: rumah.id,
        keluargaId: rumah.keluargaId,
        blok: rumah.blok,
        nomorRumah: rumah.nomorRumah,
        alamatLengkap: rumah.alamatLengkap,
        createdAt: rumah.createdAt,
      );
      await remoteDataSource.createRumah(model);
    } catch (e) {
      throw Exception("Gagal membuat data Rumah: $e");
    }
  }

  @override
  Future<void> updateRumah(Rumah rumah) async {
    try {
      final model = RumahModel(
        id: rumah.id,
        keluargaId: rumah.keluargaId,
        blok: rumah.blok,
        nomorRumah: rumah.nomorRumah,
        alamatLengkap: rumah.alamatLengkap,
        createdAt: rumah.createdAt,
      );
      await remoteDataSource.updateRumah(model);
    } catch (e) {
      throw Exception("Gagal memperbarui data Rumah: $e");
    }
  }

  @override
  Future<void> deleteRumah(int id) async {
    try {
      await remoteDataSource.deleteRumah(id);
    } catch (e) {
      throw Exception("Gagal menghapus data Rumah: $e");
    }
  }

  @override
  Future<List<Rumah>> searchRumah(String keyword) async {
    try {
      final result = await remoteDataSource.searchRumah(keyword);
      return result;
    } catch (e) {
      throw Exception("Gagal mencari Rumah: $e");
    }
  }
}
