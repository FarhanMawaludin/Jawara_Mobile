// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_app_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAppModel _$UserAppModelFromJson(Map<String, dynamic> json) => UserAppModel(
  id: json['id'] as String,
  role: json['role'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$UserAppModelToJson(UserAppModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'role': instance.role,
      'created_at': instance.createdAt.toIso8601String(),
    };
