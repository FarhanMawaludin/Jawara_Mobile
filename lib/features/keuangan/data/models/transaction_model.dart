import '../../domain/entities/transaction.dart';

class TransactionModel extends Transaction {
  TransactionModel({
    required int id,
    required TransactionType jenis,
    required String nama,
    String? kategori,
    required DateTime tanggal,
    required double jumlah,
    String? bukti,
  }) : super(
          id: id,
          jenis: jenis,
          nama: nama,
          kategori: kategori,
          tanggal: tanggal,
          jumlah: jumlah,
          bukti: bukti,
        );

  // ==========================
  //   PEMASUKAN MAPPING
  // ==========================
  factory TransactionModel.fromPemasukan(Map<String, dynamic> row) {
    return TransactionModel(
      id: row['id'] as int,
      jenis: TransactionType.pemasukan,
      nama: (row['nama_pemasukan'] ?? '') as String,
      kategori: row['kategori_pemasukan'] as String?,
      tanggal: DateTime.parse(row['tanggal_pemasukan'] as String),
      jumlah: (row['jumlah'] is int)
          ? (row['jumlah'] as int).toDouble()
          : (row['jumlah'] as num).toDouble(),
      bukti: row['bukti_pemasukan'] as String?,
    );
  }

  // ==========================
  //   PENGELUARAN MAPPING
  // ==========================
  factory TransactionModel.fromPengeluaran(Map<String, dynamic> row) {
    return TransactionModel(
      id: row['id'] as int,
      jenis: TransactionType.pengeluaran,

      // NOTE: di DB kolomnya sama: nama_pemasukan (tidak masalah)
      nama: (row['nama_pemasukan'] ?? '') as String,

      // kategori pengeluaran jika ada, kalau tidak -> "-"
      kategori: row['kategori_pengeluaran'] as String? ?? "-",

      tanggal: DateTime.parse(row['tanggal_pengeluaran'] as String),

      jumlah: (row['jumlah'] is int)
          ? (row['jumlah'] as int).toDouble()
          : (row['jumlah'] as num).toDouble(),

      // catatan dijadikan bukti jika tidak ada bukti_pengeluaran
      bukti: row['bukti_pengeluaran'] as String? ??
          row['catatan'] as String? ??
          "-",
    );
  }

  // ==========================
  //   CONVERT TO MAP
  // ==========================
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'jenis':
          jenis == TransactionType.pemasukan ? 'pemasukan' : 'pengeluaran',
      'nama': nama,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'jumlah': jumlah,
      'bukti': bukti,
    };
  }
}
