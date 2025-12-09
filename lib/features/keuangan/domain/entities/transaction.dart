enum TransactionType { pemasukan, pengeluaran }


class Transaction {
final int id;
final TransactionType jenis;
final String nama;
final String? kategori;
final DateTime tanggal;
final double jumlah;
final String? bukti;


Transaction({
required this.id,
required this.jenis,
required this.nama,
this.kategori,
required this.tanggal,
required this.jumlah,
this.bukti,
});
}