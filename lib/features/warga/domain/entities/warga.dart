// lib/domain/entities/warga.dart

class Warga {
  final int id;
  final int keluargaId;
  final String nama;
  final String? nik;
  // ENUM: 'Laki-Laki' | 'Perempuan'
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  // ENUM: 'kepala keluarga' | 'ibu rumah tangga' | 'anak'
  final String? roleKeluarga;
  final DateTime createdAt;
  final String? userId; // UUID
  final int? alamatRumahId; // BIGINT
  final String? noTelp;
  final String? tempatLahir;
  // ENUM agama
  final String? agama;

  // ENUM golongan darah
  final String? golonganDarah;

  final String? pekerjaan;
  final String? pendidikan;

  // ENUM status
  final String? status;
  final Map<String, dynamic>? keluarga;
  final Map<String, dynamic>? rumah;

  Warga({
    required this.id,
    required this.keluargaId,
    required this.nama,
    this.nik,
    this.jenisKelamin,
    this.tanggalLahir,
    this.roleKeluarga,
    required this.createdAt,
    this.userId,
    this.alamatRumahId,
    this.noTelp,
    this.tempatLahir,
    this.agama,
    this.golonganDarah,
    this.pekerjaan,
    this.status,
    this.keluarga,
    this.rumah,
    this.pendidikan,
  });
}
