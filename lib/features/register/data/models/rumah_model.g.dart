// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rumah_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RumahModel _$RumahModelFromJson(Map<String, dynamic> json) => RumahModel(
  id: (json['id'] as num).toInt(),
  keluargaId: (json['keluarga_id'] as num).toInt(),
  blok: json['blok'] as String?,
  nomorRumah: json['nomor_rumah'] as String?,
  alamatLengkap: json['alamat_lengkap'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$RumahModelToJson(RumahModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'keluarga_id': instance.keluargaId,
      'blok': instance.blok,
      'nomor_rumah': instance.nomorRumah,
      'alamat_lengkap': instance.alamatLengkap,
      'created_at': instance.createdAt.toIso8601String(),
    };
