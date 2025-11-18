// lib/data/models/warga_model.dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/warga.dart';

part 'warga_model.g.dart';

@JsonSerializable()
class WargaModel extends Warga {
  WargaModel({
    required int id,

    @JsonKey(name: 'keluarga_id')
    required int keluargaId,

    required String nama,

    String? nik,

    @JsonKey(name: 'jenis_kelamin')
    String? jenisKelamin,

    @JsonKey(name: 'tanggal_lahir')
    DateTime? tanggalLahir,

    @JsonKey(name: 'role_keluarga')
    required String roleKeluarga,

    @JsonKey(name: 'created_at')
    required DateTime createdAt,
  }) : super(
          id: id,
          keluargaId: keluargaId,
          nama: nama,
          nik: nik,
          jenisKelamin: jenisKelamin,
          tanggalLahir: tanggalLahir,
          roleKeluarga: roleKeluarga,
          createdAt: createdAt,
        );

  factory WargaModel.fromJson(Map<String, dynamic> json) =>
      _$WargaModelFromJson(json);

  Map<String, dynamic> toJson() => _$WargaModelToJson(this);
}
