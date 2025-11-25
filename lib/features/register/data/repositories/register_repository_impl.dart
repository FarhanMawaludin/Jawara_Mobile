// lib/data/repositories/register_repository_impl.dart
import '../../domain/entities/user_app.dart';
import '../../domain/entities/keluarga.dart';
import '../../domain/entities/warga.dart';
import '../../domain/entities/rumah.dart';
import '../../domain/repositories/register_repository.dart';
import '../datasources/supabase_remote_datasource.dart';

class RegisterRepositoryImpl implements RegisterRepository {
  final SupabaseRemoteDatasource datasource;

  RegisterRepositoryImpl(this.datasource);

  @override
  Future<UserApp> registerAccount(String email, String password) async {
    final model = await datasource.registerAccount(email, password);
    return UserApp(
      id: model.id,
      role: model.role,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<(Keluarga, Warga)> createKeluargaAndWarga(
    String userId,
    String namaKeluarga,
    String nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String roleKeluarga,
  ) async {
    final (keluargaModel, wargaModel) = await datasource.createKeluargaAndWarga(
      userId,
      namaKeluarga,
      nama,
      nik,
      jenisKelamin,
      tanggalLahir,
      roleKeluarga,
    );
    return (
      Keluarga(
        id: keluargaModel.id,
        userId: keluargaModel.userId,
        namaKeluarga: keluargaModel.namaKeluarga,
        createdAt: keluargaModel.createdAt,
      ),
      Warga(
        id: wargaModel.id,
        keluargaId: wargaModel.keluargaId,
        nama: wargaModel.nama,
        nik: wargaModel.nik,
        jenisKelamin: wargaModel.jenisKelamin,
        tanggalLahir: wargaModel.tanggalLahir,
        roleKeluarga: wargaModel.roleKeluarga,
        createdAt: wargaModel.createdAt,
      )
    );
  }

  @override
  Future<Rumah> createRumah(
    int keluargaId,
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  ) async {
    final model = await datasource.createRumah(
      keluargaId,
      blok,
      nomorRumah,
      alamatLengkap,
    );
    return Rumah(
      id: model.id,
      keluargaId: model.keluargaId,
      blok: model.blok,
      nomorRumah: model.nomorRumah,
      alamatLengkap: model.alamatLengkap,
      createdAt: model.createdAt,
    );
  }
}