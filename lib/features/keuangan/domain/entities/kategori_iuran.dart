class KategoriIuran {
  final int id;
  final String namaKategori;
  final String kategori; // enum: 'bulanan', 'khusus'

  KategoriIuran({
    required this.id,
    required this.namaKategori,
    required this.kategori,
  });
}