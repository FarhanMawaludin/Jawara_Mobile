class KegiatanStatisticsModel {
  final int totalKegiatan;
  final int selesai;
  final int hariIni;
  final int akanDatang;

  KegiatanStatisticsModel({
    required this.totalKegiatan,
    required this.selesai,
    required this.hariIni,
    required this.akanDatang,
  });

  factory KegiatanStatisticsModel.empty() {
    return KegiatanStatisticsModel(
      totalKegiatan: 0,
      selesai: 0,
      hariIni: 0,
      akanDatang: 0,
    );
  }

  KegiatanStatisticsModel copyWith({
    int? totalKegiatan,
    int? selesai,
    int? hariIni,
    int? akanDatang,
  }) {
    return KegiatanStatisticsModel(
      totalKegiatan: totalKegiatan ?? this.totalKegiatan,
      selesai: selesai ?? this.selesai,
      hariIni: hariIni ?? this.hariIni,
      akanDatang: akanDatang ?? this.akanDatang,
    );
  }
}