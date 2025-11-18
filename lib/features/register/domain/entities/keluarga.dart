// lib/domain/entities/keluarga.dart
class Keluarga {
  final int id;
  final String userId;
  final String namaKeluarga;
  final DateTime createdAt;

  Keluarga({
    required this.id,
    required this.userId,
    required this.namaKeluarga,
    required this.createdAt,
  });
}