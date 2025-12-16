class TagihIuran {
  final int id;
  final DateTime createdAt;
  final int kategoriId;
  final double jumlah;
  final DateTime tanggalTagihan;
  final String? buktiBayar;
  final String nama;
  final String statusTagihan; // enum dari Supabase
  final DateTime? tanggalBayar;

  TagihIuran({
    required this.id,
    required this.createdAt,
    required this.kategoriId,
    required this.jumlah,
    required this.tanggalTagihan,
    required this.nama,
    required this.statusTagihan,
    this.buktiBayar,
    this.tanggalBayar,
  });

  factory TagihIuran.fromJson(Map<String, dynamic> json) {
    return TagihIuran(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      kategoriId: json['kategori_id'],
      jumlah: json['jumlah'],
      tanggalTagihan: DateTime.parse(json['tanggal_tagihan']),
      buktiBayar: json['bukti_bayar'],
      nama: json['nama'],
      statusTagihan: json['status_tagihan'],
      tanggalBayar: json['tanggal_bayar'] != null
          ? DateTime.parse(json['tanggal_bayar'])
          : null,
    );
  }
}
