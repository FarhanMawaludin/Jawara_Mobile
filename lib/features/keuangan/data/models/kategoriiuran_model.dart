class KategoriIuranModel {
  final int?  id;
  final String namaKategori;
  final String kategoriIuran; // ✅ ENUM:  "Iuran Bulanan", "Iuran Khusus", "Iuran Lainnya"
  final double nominal; // ✅ numeric di Supabase = double di Dart
  final DateTime? createdAt;

  KategoriIuranModel({
    this.id,
    required this.namaKategori,
    required this.kategoriIuran,
    required this.nominal,
    this.createdAt,
  });

  factory KategoriIuranModel.fromJson(Map<String, dynamic> json) {
    return KategoriIuranModel(
      id: json['id'] as int?,
      createdAt: json['created_at'] != null 
          ?  DateTime.parse(json['created_at'] as String)
          : null,
      namaKategori: json['nama_kategori'] as String? ?? '',
      kategoriIuran: json['kategori_iuran'] as String? ??  '',
      nominal: (json['nominal'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'nama_kategori': namaKategori,
      'kategori_iuran': kategoriIuran, // ✅ "Iuran Bulanan" / "Iuran Khusus" / "Iuran Lainnya"
      'nominal': nominal,
    };
  }

  // ✅ Untuk UPDATE
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nama_kategori': namaKategori,
      'kategori_iuran': kategoriIuran,
      'nominal': nominal,
    };
  }
}