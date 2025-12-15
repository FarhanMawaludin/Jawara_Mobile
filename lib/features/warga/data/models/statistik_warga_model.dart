import '../../domain/entities/statistik.dart';

class StatistikWargaModel extends StatistikWarga {
  StatistikWargaModel({
    required super.totalWarga,
    required super.totalKeluarga,
    required super.laki,
    required super.perempuan,
    required super.aktif,
    required super.nonaktif,
    required super.kepalaKeluarga,
    required super.ibuRumahTangga,
    required super.anak,
    required super.agama,
    required super.pendidikan,
    required super.pekerjaan,
  });

  factory StatistikWargaModel.fromMap(Map<String, dynamic> map) {
    return StatistikWargaModel(
      totalWarga: map["total_warga"] ?? 0,
      totalKeluarga: map["total_keluarga"] ?? 0,
      laki: map["laki"] ?? 0,
      perempuan: map["perempuan"] ?? 0,
      aktif: map["aktif"] ?? 0,
      nonaktif: map["nonaktif"] ?? 0,
      kepalaKeluarga: map["kepala_keluarga"] ?? 0,
      ibuRumahTangga: map["ibu_rumah_tangga"] ?? 0,
      anak: map["anak"] ?? 0,
      agama: Map<String, int>.from(map["agama"] ?? {}),
      pendidikan: Map<String, int>.from(map["pendidikan"] ?? {}),
      pekerjaan: Map<String, int>.from(map["pekerjaan"] ?? {}),
    );
  }
}
