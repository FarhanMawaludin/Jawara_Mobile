class Metodepembayaran {
  final int id;
  final String namaMetode;
  final bool tipe; // Enum 
  final int nomorRekening;
  final String namaPemilik;
  final String fotoBarcode;
  final String thumbnail;
  final String catatan;

  Metodepembayaran({
    required this.id,
    required this.namaMetode,
    required this.tipe,
    required this.nomorRekening,
    required this.namaPemilik,
    required this.fotoBarcode,
    required this.thumbnail,
    required this.catatan,
  });
}