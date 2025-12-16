class KategoriIuran {
  final int id;
  final String namaKategori;
  final String kategoriIuran; // enum: 'bulanan', 'khusus'
  final int nominal;

  KategoriIuran({
    required this.id,
    required this.namaKategori,
    required this.kategoriIuran,
    required this.nominal,
  });
}