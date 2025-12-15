import '../../domain/entities/metodepembayaran.dart';

class MetodePembayaranModel extends Metodepembayaran {
  MetodePembayaranModel({
    int? id,
    required String namaMetode,
    required String tipe,
    required int nomorRekening,
    required String namaPemilik,
    required String? fotoBarcode,
    required String thumbnail,
    required String catatan,
    DateTime? createdAt,
  }) : super(
          id: id ?? 0,
          namaMetode: namaMetode,
          tipe: tipe,
          nomorRekening: nomorRekening,
          namaPemilik: namaPemilik,
          fotoBarcode: fotoBarcode,
          thumbnail: thumbnail,
          catatan: catatan,
          createdAt: createdAt,
        );

  /// ========== JSON → MODEL ==========
  factory MetodePembayaranModel.fromJson(Map<String, dynamic> json) {
    return MetodePembayaranModel(
      namaMetode: json['nama_metode'] as String,
      tipe: json['tipe'] as String, // pastikan di DB tipe = boolean
      nomorRekening: json['nomor_rekening'] as int,
      namaPemilik: json['nama_pemilik'] as String,
      fotoBarcode: json['foto_barcode'] as String? ?? '',
      thumbnail: json['thumbnail'] as String? ?? '',
      catatan: json['catatan'] as String? ?? '',
      createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'])
        : null,
    );
  }

  /// ========== MODEL → JSON ==========
  Map<String, dynamic> toJson() {
  return {
    if (id != 0) 'id': id,
    'nama_metode': namaMetode,
    'tipe': tipe,
    'nomor_rekening': nomorRekening,
    'nama_pemilik': namaPemilik,
    
    // Hanya kirim jika ada nilai (bukan null/kosong)
    if (fotoBarcode != null && fotoBarcode!.isNotEmpty) 
      'foto_barcode': fotoBarcode,
    
    if (thumbnail.isNotEmpty) 
      'thumbnail': thumbnail,
    
    if (catatan.isNotEmpty) 
      'catatan': catatan,
    
    // JANGAN kirim created_at, biar database yang handle
    // if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
  };
}
}
