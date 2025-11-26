import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';

class MutasiModel extends Mutasi {
  MutasiModel({
    required super.id,
    super.keluargaId,
    super.rumahId,
    super.rumahSekarangId,
    super.jenisMutasi,
    super.alasanMutasi,
    super.tanggalMutasi,
    super.keluarga,
    super.rumah,
    required super.createdAt,
  });

  MutasiModel copyWith({
    int? id,
    int? keluargaId,
    int? rumahId,
    int? rumahSekarangId,
    String? jenisMutasi,
    String? alasanMutasi,
    DateTime? tanggalMutasi,
    DateTime? createdAt,
  }) {
    return MutasiModel(
      id: id ?? this.id,
      keluargaId: keluargaId ?? this.keluargaId,
      rumahId: rumahId ?? this.rumahId,
      rumahSekarangId: rumahSekarangId ?? this.rumahSekarangId,
      jenisMutasi: jenisMutasi ?? this.jenisMutasi,
      alasanMutasi: alasanMutasi ?? this.alasanMutasi,
      tanggalMutasi: tanggalMutasi ?? this.tanggalMutasi,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory MutasiModel.fromMap(Map<String, dynamic> map) {
    return MutasiModel(
      id: map['id'],
      keluargaId: map['keluarga_id'],
      rumahId: map['rumah_id'],
      rumahSekarangId: map['rumah_sekarang_id'],
      jenisMutasi: map['jenis_mutasi'],
      alasanMutasi: map['alasan_mutasi'],
      tanggalMutasi: map['tanggal_mutasi'] != null
          ? DateTime.parse(map['tanggal_mutasi'])
          : null,

      keluarga: (map['keluarga'] != null && map['keluarga'] is Map)
          ? Map<String, dynamic>.from(map['keluarga'])
          : null,

      rumah: (map['rumah'] != null && map['rumah'] is Map)
          ? Map<String, dynamic>.from(map['rumah'])
          : null,

      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> tomap() {
    return {
      'id': id,
      'keluarga_id': keluargaId,
      'rumah_id': rumahId,
      'rumah_sekarang_id': rumahSekarangId,
      'jenis_mutasi': jenisMutasi,
      'alasan_mutasi': alasanMutasi,
      'tanggal_mutasi': tanggalMutasi?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
