class TagihIuran {
  final int id;
  final DateTime createdAt;
  final String kategoriId;
  final double jumlah;
  final DateTime tanggalTagihan;
  final String? buktiBayar;
  final String nama;
  final int keluargaId;
  final String statusTagihan; // enum dari Supabase
  final DateTime? tanggalBayar;

  TagihIuran({
    required this.id,
    required this.createdAt,
    required this.kategoriId,
    required this.jumlah,
    required this.tanggalTagihan,
    required this.nama,
    required this.keluargaId,
    required this.statusTagihan,
    this.buktiBayar,
    this.tanggalBayar,
  });
}
