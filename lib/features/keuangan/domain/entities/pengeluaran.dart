class Pengeluaran {
 final int id;
  final String namaPengeluaran;
  final double kategoriPengeluaran;
  final DateTime tanggalPengeluaran;
  final double jumlah;
  final String buktiPengeluaran;

  Pengeluaran({
    required this.id,
    required this.namaPengeluaran,
    required this.jumlah,
    required this.tanggalPengeluaran,
    required this.kategoriPengeluaran,
    required this.buktiPengeluaran,
  });
}
