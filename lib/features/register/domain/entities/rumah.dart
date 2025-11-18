// lib/domain/entities/rumah.dart
class Rumah {
  final int id;
  final int keluargaId;
  final String? blok;
  final String? nomorRumah;
  final String? alamatLengkap;
  final DateTime createdAt;

  Rumah({
    required this.id,
    required this.keluargaId,
    required this.blok,
    required this.nomorRumah,
    required this.alamatLengkap,
    required this.createdAt,
  });
}