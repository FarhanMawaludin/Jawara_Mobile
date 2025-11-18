// lib/domain/repositories/register_repository.dart
import '../entities/user_app.dart';
import '../entities/keluarga.dart';
import '../entities/warga.dart';
import '../entities/rumah.dart';

abstract class RegisterRepository {
  Future<UserApp> registerAccount(String email, String password);
  Future<(Keluarga, Warga)> createKeluargaAndWarga(
    String userId,
    String namaKeluarga,
    String nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String roleKeluarga,
  );
  Future<Rumah> createRumah(
    int keluargaId,
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  );
}