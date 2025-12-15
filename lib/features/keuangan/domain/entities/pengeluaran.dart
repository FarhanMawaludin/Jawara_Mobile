class Pengeluaran {
  final int id;
  final DateTime createdAt;
  final String namaPengeluaran;
  final String kategoriPengeluaran;
  final DateTime tanggalPengeluaran;
  final double jumlah;
  final String buktiPengeluaran;

  Pengeluaran({
    required this.id,
    required this.createdAt,
    required this.namaPengeluaran,
    required this.jumlah,
    required this.tanggalPengeluaran,
    required this.kategoriPengeluaran,
    required this.buktiPengeluaran,
  });
}
