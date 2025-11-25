// lib/data/models/rumah_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/rumah.dart';

part 'rumah_model.g.dart';

@JsonSerializable()
class RumahModel extends Rumah {
  RumahModel({
    required super.id,

    @JsonKey(name: 'keluarga_id')
    required super.keluargaId,

    super.blok,

    @JsonKey(name: 'nomor_rumah')
    super.nomorRumah,

    @JsonKey(name: 'alamat_lengkap')
    super.alamatLengkap,

    @JsonKey(name: 'created_at')
    required super.createdAt,
  });

  factory RumahModel.fromJson(Map<String, dynamic> json) =>
      _$RumahModelFromJson(json);

  Map<String, dynamic> toJson() => _$RumahModelToJson(this);
}
