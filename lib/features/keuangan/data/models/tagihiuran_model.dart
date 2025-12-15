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
    super.tanggalBayar,
  });

  factory TagihIuranModel.fromJson(Map<String, dynamic> json) {
    return TagihIuranModel(
      id: json['id'],
      createdAt: DateTime.parse(json['created_at']),
      kategoriId: json['kategori_id'],
      jumlah: double.tryParse(json['jumlah'].toString()) ?? 0.0,
      tanggalTagihan: DateTime.parse(json['tanggal_tagihan']),
      nama: json['nama'],
      statusTagihan: json['status_tagihan'],
      buktiBayar: json['bukti_bayar'],
      tanggalBayar: json['tanggal_bayar'] != null
          ? DateTime.parse(json['tanggal_bayar'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Jangan kirim 'id' saat insert, biarkan database auto-generate
      if (id != 0) 'id': id,
      'created_at': createdAt.toIso8601String(),
      'kategori_id': kategoriId,
      'jumlah': jumlah,
      'tanggal_tagihan': tanggalTagihan.toIso8601String(),
      'bukti_bayar': buktiBayar,
      'nama': nama,
      'status_tagihan': statusTagihan,
      'tanggal_bayar': tanggalBayar?.toIso8601String(),
    };
  }
}
