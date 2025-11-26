class MetodePembayaran {
  final int id;
  final String namaMetode;
  final String tipe; // enum: 'bank', 'e-wallet', 'qris'
  final String nomorRekening;
  final String namaPemilik;
  final String fotoBarcode;
  final String thumbnail;
  final String catatan;

  MetodePembayaran({
    required this.id,
    required this.namaMetode,
    required this.tipe,
    required this.nomorRekening,
    required this.namaPemilik,
    required this.fotoBarcode,
    required this.thumbnail,
    required this.catatan,
  });

  factory MetodePembayaran.fromJson(Map<String, dynamic> json) {
    return MetodePembayaran(
      id: json['id'],
      namaMetode: json['nama_metode'],
      tipe: json['tipe'],
      nomorRekening: json['nomor_rekening'],
      namaPemilik: json['nama_pemilik'],
      fotoBarcode: json['foto_barcode'],
      thumbnail: json['thumbnail'],
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_metode': namaMetode,
      'tipe': tipe,
      'nomor_rekening': nomorRekening,
      'nama_pemilik': namaPemilik,
      'foto_barcode': fotoBarcode,
      'thumbnail': thumbnail,
      'catatan': catatan,
    };
  }
}
