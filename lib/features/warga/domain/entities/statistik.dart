class StatistikWarga {
  final int totalWarga;
  final int totalKeluarga;
  final int laki;
  final int perempuan;
  final int aktif;
  final int nonaktif;

  final int kepalaKeluarga;
  final int ibuRumahTangga;
  final int anak;

  final Map<String, int> agama;
  final Map<String, int> pendidikan;
  final Map<String, int> pekerjaan;

  StatistikWarga({
    required this.totalWarga,
    required this.totalKeluarga,
    required this.laki,
    required this.perempuan,
    required this.aktif,
    required this.nonaktif,
    required this.kepalaKeluarga,
    required this.ibuRumahTangga,
    required this.anak,
    required this.agama,
    required this.pendidikan,
    required this.pekerjaan,
  });
}
