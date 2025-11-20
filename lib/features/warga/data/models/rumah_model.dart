import '../../domain/entities/rumah.dart';

class RumahModel extends Rumah {
  RumahModel({
    required super.id,
    super.keluargaId,
    super.blok,
    super.nomorRumah,
    super.alamatLengkap,
    required super.createdAt,
  });

  factory RumahModel.fromMap(Map<String, dynamic> map) {
    return RumahModel(
      id: map['id'],
      keluargaId: map['keluarga_id'],
      blok: map['blok'],
      nomorRumah: map['nomor_rumah'],
      alamatLengkap: map['alamat_lengkap'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'keluarga_id': keluargaId,
      'blok': blok,
      'nomor_rumah': nomorRumah,
      'alamat_lengkap': alamatLengkap,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
