class StatistikModel {
  final double totalPemasukan;
  final double totalPengeluaran;

  final List<double> pemasukanBulanan;
  final List<double> pengeluaranBulanan;

  final Map<String, double> kategoriPemasukan;
  final Map<String, double> kategoriPengeluaran;

  StatistikModel({
    required this.totalPemasukan,
    required this.totalPengeluaran,
    required this.pemasukanBulanan,
    required this.pengeluaranBulanan,
    required this.kategoriPemasukan,
    required this.kategoriPengeluaran,
  });

  factory StatistikModel.empty() {
    return StatistikModel(
      totalPemasukan: 0,
      totalPengeluaran: 0,
      pemasukanBulanan: List<double>.filled(12, 0),
      pengeluaranBulanan: List<double>.filled(12, 0),
      kategoriPemasukan: {},
      kategoriPengeluaran: {},
    );
  }
}
