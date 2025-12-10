import '../../domain/entities/mutasi.dart';

class MutasiModel extends Mutasi {
  MutasiModel({
    required super.id,
    required super.jenis,
    required super.nama,
    super.kategori,
    required super.tanggal,
    required super.jumlah,
    super.bukti,
  });

  // ==========================
  //   PEMASUKAN MAPPING
  // ==========================
  factory MutasiModel.fromPemasukan(Map<String, dynamic> row) {
    return MutasiModel(
      id: row['id'] as int,
      jenis: MutasiType.pemasukan,
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
  factory MutasiModel.fromPengeluaran(Map<String, dynamic> row) {
    return MutasiModel(
      id: row['id'] as int,
      jenis: MutasiType.pengeluaran,

      // NOTE: di DB kolomnya sama: nama_pemasukan (tidak masalah)
      nama: (row['nama_pengeluaran'] ?? '') as String,

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
      // Jangan kirim 'id' saat insert, biarkan database auto-generate
      if (id != 0) 'id': id,
      'jenis':
          jenis == MutasiType.pemasukan ? 'pemasukan' : 'pengeluaran',
      'nama': nama,
      'kategori': kategori,
      'tanggal': tanggal.toIso8601String(),
      'jumlah': jumlah,
      'bukti': bukti,
    };
  }
}
