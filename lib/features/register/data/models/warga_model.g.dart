// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'warga_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WargaModel _$WargaModelFromJson(Map<String, dynamic> json) => WargaModel(
  id: (json['id'] as num).toInt(),
  keluargaId: (json['keluarga_id'] as num).toInt(),
  nama: json['nama'] as String,
  nik: json['nik'] as String?,
  jenisKelamin: json['jenis_kelamin'] as String?,
  tanggalLahir: json['tanggal_lahir'] == null
      ? null
      : DateTime.parse(json['tanggal_lahir'] as String),
  roleKeluarga: json['role_keluarga'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$WargaModelToJson(WargaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keluarga_id': instance.keluargaId,
      'nama': instance.nama,
      'nik': instance.nik,
      'jenis_kelamin': instance.jenisKelamin,
      'tanggal_lahir': instance.tanggalLahir?.toIso8601String(),
      'role_keluarga': instance.roleKeluarga,
      'created_at': instance.createdAt.toIso8601String(),
    };
