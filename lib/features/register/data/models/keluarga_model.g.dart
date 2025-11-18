// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'keluarga_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KeluargaModel _$KeluargaModelFromJson(Map<String, dynamic> json) =>
    KeluargaModel(
      id: (json['id'] as num).toInt(),
      userId: json['user_id'] as String,
      namaKeluarga: json['nama_keluarga'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$KeluargaModelToJson(KeluargaModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'nama_keluarga': instance.namaKeluarga,
      'created_at': instance.createdAt.toIso8601String(),
    };
