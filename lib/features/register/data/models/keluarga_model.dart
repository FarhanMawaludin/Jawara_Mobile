// lib/data/models/keluarga_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/keluarga.dart';

part 'keluarga_model.g.dart';

@JsonSerializable()
class KeluargaModel extends Keluarga {
  KeluargaModel({
    required super.id,
    @JsonKey(name: 'user_id') required super.userId,
    @JsonKey(name: 'nama_keluarga') required super.namaKeluarga,
    @JsonKey(name: 'created_at') required super.createdAt,
  });

  factory KeluargaModel.fromJson(Map<String, dynamic> json) =>
      _$KeluargaModelFromJson(json);
  Map<String, dynamic> toJson() => _$KeluargaModelToJson(this);
}
