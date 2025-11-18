// lib/data/models/rumah_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/rumah.dart';

part 'rumah_model.g.dart';

@JsonSerializable()
class RumahModel extends Rumah {
  RumahModel({
    required int id,

    @JsonKey(name: 'keluarga_id')
    required int keluargaId,

    String? blok,

    @JsonKey(name: 'nomor_rumah')
    String? nomorRumah,

    @JsonKey(name: 'alamat_lengkap')
    String? alamatLengkap,

    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) : super(
          id: id,
          keluargaId: keluargaId,
          blok: blok,
          nomorRumah: nomorRumah,
          alamatLengkap: alamatLengkap,
          createdAt: createdAt,
        );

  factory RumahModel.fromJson(Map<String, dynamic> json) =>
      _$RumahModelFromJson(json);

  Map<String, dynamic> toJson() => _$RumahModelToJson(this);
}
