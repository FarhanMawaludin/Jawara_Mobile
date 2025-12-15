import 'package:jawaramobile/features/warga/data/models/mutasi_model.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/warga/data/datasources/mutasi_remote_datasource.dart';

class MutasiRepositoryImpl implements MutasiRepository {
  final MutasiRemoteDataSource remoteDataSource;

  MutasiRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Mutasi>> getAllMutasi() async {
    try {
      return await remoteDataSource.getAllMutasi();
    } catch (e) {
      throw Exception("Gagal mengambil semua data Mutasi: $e");
    }
  }

  @override
  Future<Mutasi?> getMutasiByKeluarga(int keluargaId) async {
    try {
      return await remoteDataSource.getMutasiByKeluarga(keluargaId);
    } catch (e) {
      throw Exception("Gagal mengambil Mutasi berdasarkan keluarga_id: $e");
    }
  }

  @override
  Future<Mutasi?> getMutasiById(int id) async {
    try {
      return await remoteDataSource.getMutasiById(id);
    } catch (e) {
      throw Exception("Gagal mengambil detail Mutasi: $e");
    }
  }

  @override
  Future<void> createMutasi(Mutasi mutasi) async {
    try {
      final model = MutasiModel(
        id: mutasi.id,
        keluargaId: mutasi.keluargaId,
        rumahId: mutasi.rumahId,
        rumahSekarangId: mutasi.rumahSekarangId,
        jenisMutasi: mutasi.jenisMutasi,
        tanggalMutasi: mutasi.tanggalMutasi,
        alasanMutasi: mutasi.alasanMutasi,
        createdAt: mutasi.createdAt,
      );
      await remoteDataSource.createMutasi(model);
    } catch (e) {
      throw Exception("Gagal membuat data Mutasi: $e");
    }
  }

  @override
  Future<List<Mutasi>> searchMutasi(String keyword) async {
    try {
      final result = await remoteDataSource.searchMutasi(keyword);
      return result;
    } catch (e) {
      throw Exception("Gagal mencari data Mutasi: $e");
    }
  }

  @override
  Future<void> updateRumah(int keluargaId, int? rumahId) async {
    try {
      await remoteDataSource.updateRumah(keluargaId, rumahId);
    } catch (e) {
      throw Exception("Gagal mengupdate rumah keluarga: $e");
    }
  }
}