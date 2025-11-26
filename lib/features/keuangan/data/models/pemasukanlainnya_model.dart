class PemasukanLainnya {
  final int id;
  final String namaPemasukan;
  final DateTime tanggalPemasukan;
  final String kategoriPemasukan; // enum
  final double jumlah;
  final String buktiPemasukan;

  PemasukanLainnya({
    required this.id,
    required this.namaPemasukan,
    required this.tanggalPemasukan,
    required this.kategoriPemasukan,
    required this.jumlah,
    required this.buktiPemasukan,
  });

  factory PemasukanLainnya.fromJson(Map<String, dynamic> json) {
    return PemasukanLainnya(
      id: json['id'],
      namaPemasukan: json['nama_pemasukan'],
      tanggalPemasukan: DateTime.parse(json['tanggal_pemasukan']),
      kategoriPemasukan: json['kategori_pemasukan'],
      jumlah: (json['jumlah'] as num).toDouble(),
      buktiPemasukan: json['bukti_pemasukan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pemasukan': namaPemasukan,
      'tanggal_pemasukan': tanggalPemasukan.toIso8601String(),
      'kategori_pemasukan': kategoriPemasukan,
      'jumlah': jumlah,
      'bukti_pemasukan': buktiPemasukan,
    };
  }
}
