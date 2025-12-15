// lib/data/models/warga_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/warga.dart';

part 'warga_model.g.dart';

@JsonSerializable()
class WargaModel extends Warga {
  WargaModel({
    required super.id,

    @JsonKey(name: 'keluarga_id')
    required super.keluargaId,

    required super.nama,

    super.nik,

    @JsonKey(name: 'jenis_kelamin')
    super.jenisKelamin,

    @JsonKey(name: 'tanggal_lahir')
    super.tanggalLahir,

    @JsonKey(name: 'role_keluarga')
    required super.roleKeluarga,

    @JsonKey(name: 'created_at')
    required super.createdAt,
  });

  factory WargaModel.fromJson(Map<String, dynamic> json) =>
      _$WargaModelFromJson(json);

  Map<String, dynamic> toJson() => _$WargaModelToJson(this);
}
