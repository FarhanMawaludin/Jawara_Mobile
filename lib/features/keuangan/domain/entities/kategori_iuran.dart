class KategoriIuran {
  final int id;
  final String namaKategori;
  final String kategoriIuran; // enum: 'bulanan', 'khusus'

  KategoriIuran({
    required this.id,
    required this.namaKategori,
    required this.kategoriIuran,
  });
}