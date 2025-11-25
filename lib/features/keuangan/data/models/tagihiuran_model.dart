class TagihIuran {
  final int id;
  final int kategoriIuranId;
  final int keluargaId;
  final DateTime tanggalTagihan;
  final double jumlah;
  final String statusTagihan; // enum: 'belum_bayar', 'sudah_bayar'
  final DateTime? tanggalBayar;
  final String? buktiBayar;

  TagihIuran({
    required this.id,
    required this.kategoriIuranId,
    required this.keluargaId,
    required this.tanggalTagihan,
    required this.jumlah,
    required this.statusTagihan,
    this.tanggalBayar,
    this.buktiBayar,
  });

  factory TagihIuran.fromJson(Map<String, dynamic> json) {
    return TagihIuran(
      id: json['id'],
      kategoriIuranId: json['kategori_iuran_id'],
      keluargaId: json['keluarga_id'],
      tanggalTagihan: DateTime.parse(json['tanggal_tagihan']),
      jumlah: (json['jumlah'] as num).toDouble(),
      statusTagihan: json['status_tagihan'],
      tanggalBayar: json['tanggal_bayar'] != null
          ? DateTime.parse(json['tanggal_bayar'])
          : null,
      buktiBayar: json['bukti_bayar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_iuran_id': kategoriIuranId,
      'keluarga_id': keluargaId,
      'tanggal_tagihan': tanggalTagihan.toIso8601String(),
      'jumlah': jumlah,
      'status_tagihan': statusTagihan,
      'tanggal_bayar': tanggalBayar?.toIso8601String(),
      'bukti_bayar': buktiBayar,
    };
  }
}
