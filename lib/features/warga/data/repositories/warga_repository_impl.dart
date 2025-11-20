import '../../domain/entities/warga.dart';
import '../../domain/repositories/warga_repository.dart';
import '../datasources/warga_remote_datasource.dart';
import '../models/warga_model.dart';

class WargaRepositoryImpl implements WargaRepository {
  final WargaRemoteDataSource remoteDataSource;

  WargaRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Warga>> getAllWarga() async {
    return await remoteDataSource.getAllWarga();
  }

  @override
  Future<Warga?> getWargaById(int id) async {
    return await remoteDataSource.getWargaById(id);
  }

  @override
  Future<List<Warga>> searchWarga(String keyword) async {
    final result = await remoteDataSource.searchWarga(keyword);

    // result = List<WargaModel>
    // Domain butuh List<Warga>, tapi WargaModel extends Warga
    return result;
  }

  @override
  Future<void> createWarga(Warga warga) async {
    final model = WargaModel(
      id: warga.id,
      keluargaId: warga.keluargaId,
      nama: warga.nama,
      nik: warga.nik,
      jenisKelamin: warga.jenisKelamin,
      tanggalLahir: warga.tanggalLahir,
      roleKeluarga: warga.roleKeluarga,
      createdAt: warga.createdAt,
      userId: warga.userId,
      alamatRumahId: warga.alamatRumahId,
      noTelp: warga.noTelp,
      tempatLahir: warga.tempatLahir,
      agama: warga.agama,
      golonganDarah: warga.golonganDarah,
      pekerjaan: warga.pekerjaan,
      status: warga.status,
    );
    await remoteDataSource.createWarga(model);
  }

  @override
  Future<void> updateWarga(Warga warga) async {
    final model = WargaModel(
      id: warga.id,
      keluargaId: warga.keluargaId,
      nama: warga.nama,
      nik: warga.nik,
      jenisKelamin: warga.jenisKelamin,
      tanggalLahir: warga.tanggalLahir,
      roleKeluarga: warga.roleKeluarga,
      createdAt: warga.createdAt,
      userId: warga.userId,
      alamatRumahId: warga.alamatRumahId,
      noTelp: warga.noTelp,
      tempatLahir: warga.tempatLahir,
      agama: warga.agama,
      golonganDarah: warga.golonganDarah,
      pekerjaan: warga.pekerjaan,
      status: warga.status,
    );
    await remoteDataSource.updateWarga(model);
  }

  @override
  Future<void> deleteWarga(int id) async {
    await remoteDataSource.deleteWarga(id);
  }
}
