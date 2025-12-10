
class KategoriIuranModel {
  final int id;
  final String namaKategori;
  final String kategoriIuran; // enum: 'bulanan', 'khusus'
  final DateTime? createdAt;

  KategoriIuranModel({
    required this.id,
    required this.namaKategori,
    required this.kategoriIuran,
    required this.createdAt,
  });

   factory KategoriIuranModel.fromJson(Map<String, dynamic> json) {
    return KategoriIuranModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      namaKategori: json['nama_kategori'] as String? ?? '',
      kategoriIuran: json['kategori_iuran'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt?.toIso8601String(),
      'nama_kategori': namaKategori,
      'kategori_iuran': kategoriIuran,
    };
  }
}
