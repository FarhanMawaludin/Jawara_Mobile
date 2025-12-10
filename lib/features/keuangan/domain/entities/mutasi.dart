enum MutasiType { pemasukan, pengeluaran }


class Mutasi {
  final int id;
  final MutasiType jenis;
  final String nama;
  final String? kategori;
  final DateTime tanggal;
  final double jumlah;
  final String? bukti;


Mutasi({
  required this.id,
  required this.jenis,
  required this.nama,
  this.kategori,
  required this.tanggal,
  required this.jumlah,
  this.bukti,
});
}