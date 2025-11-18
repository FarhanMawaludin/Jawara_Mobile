// lib/data/models/keluarga_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/keluarga.dart';

part 'keluarga_model.g.dart';

@JsonSerializable()
class KeluargaModel extends Keluarga {
  KeluargaModel({
    required int id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'nama_keluarga') required String namaKeluarga,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) : super(
          id: id,
          userId: userId,
          namaKeluarga: namaKeluarga,
          createdAt: createdAt,
        );

  factory KeluargaModel.fromJson(Map<String, dynamic> json) =>
      _$KeluargaModelFromJson(json);
  Map<String, dynamic> toJson() => _$KeluargaModelToJson(this);
}
