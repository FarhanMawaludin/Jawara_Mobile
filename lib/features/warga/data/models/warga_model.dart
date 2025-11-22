import '../../domain/entities/warga.dart';

class WargaModel extends Warga {
  WargaModel({
    required super.id,
    required super.keluargaId,
    required super.nama,
    super.nik,
    super.jenisKelamin,
    super.tanggalLahir,
    super.roleKeluarga,
    required super.createdAt,
    super.userId,
    super.alamatRumahId,
    super.noTelp,
    super.tempatLahir,
    super.agama,
    super.golonganDarah,
    super.pekerjaan,
    super.status,

    // inherited from entity
    super.keluarga,
    super.rumah,
  });

  factory WargaModel.fromMap(Map<String, dynamic> map) {
    return WargaModel(
      id: map['id'],
      keluargaId: map['keluarga_id'],
      nama: map['nama'],
      nik: map['nik'],
      jenisKelamin: map['jenis_kelamin'],
      tanggalLahir: map['tanggal_lahir'] != null
          ? DateTime.parse(map['tanggal_lahir'])
          : null,
      roleKeluarga: map['role_keluarga'],
      createdAt: DateTime.parse(map['created_at']),
      userId: map['user_id'],
      alamatRumahId: map['alamat_rumah_id'],
      noTelp: map['no_telp'],
      tempatLahir: map['tempat_lahir'],
      agama: map['agama'],
      golonganDarah: map['golongan_darah'],
      pekerjaan: map['pekerjaan'],
      status: map['status'],

      // nested keluarga
      keluarga: (map['keluarga'] != null && map['keluarga'] is Map)
          ? Map<String, dynamic>.from(map['keluarga'])
          : null,

      // nested rumah
      rumah: (map['rumah'] != null && map['rumah'] is Map)
          ? Map<String, dynamic>.from(map['rumah'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'keluarga_id': keluargaId,
      'nama': nama,
      'nik': nik,
      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'role_keluarga': roleKeluarga,
      'created_at': createdAt.toIso8601String(),
      'user_id': userId,
      'alamat_rumah_id': alamatRumahId,
      'no_telp': noTelp,
      'tempat_lahir': tempatLahir,
      'agama': agama,
      'golongan_darah': golonganDarah,
      'pekerjaan': pekerjaan,
      'status': status,

      // ❌ Tidak mengirim nested rumah & keluarga ke DB
    };
  }
}
