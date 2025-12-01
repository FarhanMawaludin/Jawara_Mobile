class KegiatanFormModel {
  final String namaKegiatan;
  final DateTime? tanggalKegiatan;
  final String lokasi;
  final String penanggungJawab;
  final String kategori;
  final String deskripsi;

  KegiatanFormModel({
    this.namaKegiatan = '',
    this.tanggalKegiatan,
    this.lokasi = '',
    this.penanggungJawab = '',
    this.kategori = '',
    this.deskripsi = '',
  });

  bool get isEmpty =>
      namaKegiatan.isEmpty &&
      tanggalKegiatan == null &&
      lokasi.isEmpty &&
      penanggungJawab.isEmpty &&
      kategori.isEmpty &&
      deskripsi.isEmpty;

  // Helper untuk mendapatkan kategori dalam format display (Title Case)
  String get kategoriDisplay {
    if (kategori.isEmpty) return '';
    return kategori[0].toUpperCase() + kategori.substring(1).toLowerCase();
  }

  KegiatanFormModel copyWith({
    String? namaKegiatan,
    DateTime? tanggalKegiatan,
    String? lokasi,
    String? penanggungJawab,
    String? kategori,
    String? deskripsi,
  }) {
    return KegiatanFormModel(
      namaKegiatan: namaKegiatan ?? this.namaKegiatan,
      tanggalKegiatan: tanggalKegiatan ?? this.tanggalKegiatan,
      lokasi: lokasi ?? this.lokasi,
      penanggungJawab: penanggungJawab ?? this.penanggungJawab,
      kategori: kategori ?? this.kategori,
      deskripsi: deskripsi ?? this.deskripsi,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_kegiatan': namaKegiatan,
      'tanggal_kegiatan': tanggalKegiatan?.toIso8601String(),
      'lokasi_kegiatan': lokasi,
      'penanggung_jawab_kegiatan': penanggungJawab,
      'kategori_kegiatan': kategori.toLowerCase(), // Selalu lowercase untuk database
      'deskripsi_kegiatan': deskripsi,
    };
  }

  factory KegiatanFormModel.fromJson(Map<String, dynamic> json) {
    return KegiatanFormModel(
      namaKegiatan: json['nama_kegiatan'] ?? '',
      tanggalKegiatan: json['tanggal_kegiatan'] != null
          ? DateTime.parse(json['tanggal_kegiatan'])
          : null,
      lokasi: json['lokasi_kegiatan'] ?? '',
      penanggungJawab: json['penanggung_jawab_kegiatan'] ?? '',
      kategori: json['kategori_kegiatan'] ?? '',
      deskripsi: json['deskripsi_kegiatan'] ?? '',
    );
  }
}