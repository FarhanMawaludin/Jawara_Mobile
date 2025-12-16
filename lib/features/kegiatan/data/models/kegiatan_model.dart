enum KategoriKegiatan {
  sosial,
  keagamaan,
  olahraga,
  pendidikan,
  kesehatan,
  lainnya;

  String get displayName {
    switch (this) {
      case KategoriKegiatan.sosial:
        return 'Sosial';
      case KategoriKegiatan.keagamaan:
        return 'Keagamaan';
      case KategoriKegiatan.olahraga:
        return 'Olahraga';
      case KategoriKegiatan.pendidikan:
        return 'Pendidikan';
      case KategoriKegiatan.kesehatan:
        return 'Kesehatan';
      case KategoriKegiatan.lainnya:
        return 'Lainnya';
    }
  }

  static KategoriKegiatan fromString(String? value) {
    if (value == null) return KategoriKegiatan.lainnya;
    
    switch (value.toLowerCase()) {
      case 'sosial':
        return KategoriKegiatan.sosial;
      case 'keagamaan':
        return KategoriKegiatan.keagamaan;
      case 'olahraga':
        return KategoriKegiatan.olahraga;
      case 'pendidikan':
        return KategoriKegiatan.pendidikan;
      case 'kesehatan':
        return KategoriKegiatan.kesehatan;
      default:
        return KategoriKegiatan.lainnya;
    }
  }
}

class KegiatanModel {
  final int id;
  final String namaKegiatan;
  final KategoriKegiatan kategoriKegiatan;
  final DateTime? tanggalKegiatan;
  final String? lokasiKegiatan;
  final String? penanggungJawabKegiatan;
  final String? deskripsiKegiatan;
  final DateTime? createdAt;

  KegiatanModel({
    required this.id,
    required this.namaKegiatan,
    required this.kategoriKegiatan,
    this.tanggalKegiatan,
    this.lokasiKegiatan,
    this.penanggungJawabKegiatan,
    this.deskripsiKegiatan,
    this.createdAt,
  });

  factory KegiatanModel.fromJson(Map<String, dynamic> json) {
    return KegiatanModel(
      id: json['id'] as int,
      namaKegiatan: json['nama_kegiatan'] as String? ?? '',
      kategoriKegiatan: KategoriKegiatan.fromString(
        json['kategori_kegiatan'] as String?,
      ),
      tanggalKegiatan: json['tanggal_kegiatan'] != null
          ? DateTime.parse(json['tanggal_kegiatan'] as String)
          : null,
      lokasiKegiatan: json['lokasi_kegiatan'] as String?,
      penanggungJawabKegiatan: json['penanggung_jawab_kegiatan'] as String?,
      deskripsiKegiatan: json['deskripsi_kegiatan'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_kegiatan': namaKegiatan,
      'kategori_kegiatan': kategoriKegiatan.name,
      'tanggal_kegiatan': tanggalKegiatan?.toIso8601String(),
      'lokasi_kegiatan': lokasiKegiatan,
      'penanggung_jawab_kegiatan': penanggungJawabKegiatan,
      'deskripsi_kegiatan': deskripsiKegiatan,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Helper untuk status kegiatan
  String get status {
    if (tanggalKegiatan == null) return 'Tanggal Belum Ditentukan';
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final kegiatanDate = DateTime(
      tanggalKegiatan!.year,
      tanggalKegiatan!.month,
      tanggalKegiatan!.day,
    );

    if (kegiatanDate.isBefore(today)) {
      return 'Selesai';
    } else if (kegiatanDate.isAtSameMomentAs(today)) {
      return 'Hari Ini';
    } else {
      return 'Akan Datang';
    }
  }

  bool get isUpcoming => status == 'Akan Datang' || status == 'Hari Ini';

  KegiatanModel copyWith({
    int? id,
    String? namaKegiatan,
    KategoriKegiatan? kategoriKegiatan,
    DateTime? tanggalKegiatan,
    String? lokasiKegiatan,
    String? penanggungJawabKegiatan,
    String? deskripsiKegiatan,
    DateTime? createdAt,
  }) {
    return KegiatanModel(
      id: id ?? this.id,
      namaKegiatan: namaKegiatan ?? this.namaKegiatan,
      kategoriKegiatan: kategoriKegiatan ?? this.kategoriKegiatan,
      tanggalKegiatan: tanggalKegiatan ?? this.tanggalKegiatan,
      lokasiKegiatan: lokasiKegiatan ?? this.lokasiKegiatan,
      penanggungJawabKegiatan:
          penanggungJawabKegiatan ?? this.penanggungJawabKegiatan,
      deskripsiKegiatan: deskripsiKegiatan ?? this.deskripsiKegiatan,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'KegiatanModel(id: $id, nama: $namaKegiatan, kategori: ${kategoriKegiatan.displayName})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KegiatanModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}