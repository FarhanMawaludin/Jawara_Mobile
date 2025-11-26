class Pengeluaran {
  final int id;
  final String nama;
  final double jumlah;
  final DateTime tanggal;
  final String? catatan;

  Pengeluaran({
    required this.id,
    required this.nama,
    required this.jumlah,
    required this.tanggal,
    this.catatan,
  });
}
