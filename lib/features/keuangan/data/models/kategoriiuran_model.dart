
class KategoriIuran {
  final int id;
  final String namaIuran;
  final String kategori; // enum: 'bulanan', 'khusus'

  KategoriIuran({
    required this.id,
    required this.namaIuran,
    required this.kategori,
  });

  factory KategoriIuran.fromJson(Map<String, dynamic> json) {
    return KategoriIuran(
      id: json['id'],
      namaIuran: json['nama_iuran'],
      kategori: json['kategori'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_iuran': namaIuran,
      'kategori': kategori,
    };
  }
}
