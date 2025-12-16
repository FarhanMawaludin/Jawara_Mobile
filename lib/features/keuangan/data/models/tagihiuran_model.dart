import '../../domain/entities/tagihiuran.dart';

class TagihIuranModel extends TagihIuran {
  TagihIuranModel({
    required super.id,
    required super.createdAt,
    required super.kategoriId,
    required super.jumlah,
    required super.tanggalTagihan,
    required super.nama,
    required super.statusTagihan,
    super.buktiBayar,
    super. tanggalBayar,
  });

 factory TagihIuranModel.fromJson(Map<String, dynamic> json) {
  return TagihIuranModel(
    id: json['id'] as int,
    createdAt: json['created_at'] != null 
        ? DateTime.parse(json['created_at'] as String)
        : DateTime.now(),
    kategoriId: json['kategori_id'] as int,
    
    // ✅ Pakai helper _parseDouble
    jumlah:  _parseDouble(json['jumlah']),
    
    tanggalTagihan: DateTime.parse(json['tanggal_tagihan'] as String),
    nama: json['nama'] as String,
    statusTagihan: json['status_tagihan'] as String? ?? 'belum_bayar',
    buktiBayar: json['bukti_bayar'] as String?,
    tanggalBayar: json['tanggal_bayar'] != null
        ? DateTime.parse(json['tanggal_bayar'] as String)
        : null,
  );
}

// ✅ Helper method
static double _parseDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}

  // ✅ Untuk INSERT (tanpa id dan created_at)
  Map<String, dynamic> toJsonForInsert() {
    return {
      'kategori_id': kategoriId,
      'jumlah': jumlah,
      'tanggal_tagihan':  tanggalTagihan.toIso8601String().split('T')[0], // ✅ YYYY-MM-DD
      'nama': nama,
      'status_tagihan': statusTagihan,
      if (buktiBayar != null) 'bukti_bayar': buktiBayar,
      if (tanggalBayar != null) 'tanggal_bayar': tanggalBayar! .toIso8601String().split('T')[0],
    };
  }

  // ✅ Untuk UPDATE (dengan id, tanpa created_at)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kategori_id': kategoriId,
      'jumlah': jumlah,
      'tanggal_tagihan': tanggalTagihan.toIso8601String().split('T')[0],
      'nama': nama,
      'status_tagihan': statusTagihan,
      if (buktiBayar != null) 'bukti_bayar': buktiBayar,
      if (tanggalBayar != null) 'tanggal_bayar': tanggalBayar!.toIso8601String().split('T')[0],
    };
  }
}