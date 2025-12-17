class TagihIuran {
  final int id;
  final DateTime createdAt;
  final int kategoriId;
  final double jumlah;
  final DateTime tanggalTagihan;
  final String?  buktiBayar;
  final String nama;
  final String statusTagihan;
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
    try {
      print('🔍 [TagihIuran.fromJson] Parsing: $json');
      
      return TagihIuran(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        kategoriId: json['kategori_id'] as int,
        jumlah: (json['jumlah'] as num).toDouble(),
        tanggalTagihan: DateTime.parse(json['tanggal_tagihan'] as String),
        buktiBayar: json['bukti_bayar'] as String?,
        nama: json['nama'] as String,
        statusTagihan: json['status_tagihan'] as String,
        tanggalBayar: json['tanggal_bayar'] != null
            ? DateTime.parse(json['tanggal_bayar'] as String)
            : null,
      );
    } catch (e, st) {
      print('❌ [TagihIuran.fromJson] Error: $e');
      print('📍 Failed JSON: $json');
      print('📍 StackTrace:  $st');
      rethrow;
    }
  }
}