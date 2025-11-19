import '../../domain/entities/warga.dart';

class WargaModel extends Warga {
  final Map<String, dynamic>? keluarga;
  final Map<String, dynamic>? rumah;

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

    this.keluarga,
    this.rumah,
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
      keluarga: map['keluarga'] is Map ? map['keluarga'] : null,
      rumah: map['rumah'] is Map ? map['rumah'] : null,
    );
  }

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
    };
  }
}
