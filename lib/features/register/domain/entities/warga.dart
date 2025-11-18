// lib/domain/entities/warga.dart
class Warga {
  final int id;
  final int keluargaId;
  final String nama;
  final String? nik;
  final String? jenisKelamin;
  final DateTime? tanggalLahir;
  final String roleKeluarga;
  final DateTime createdAt;

  Warga({
    required this.id,
    required this.keluargaId,
    required this.nama,
    required this.nik,
    required this.jenisKelamin,
    required this.tanggalLahir,
    required this.roleKeluarga,
    required this.createdAt,
  });
}