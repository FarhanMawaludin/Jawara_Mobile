import '../../domain/entities/pengeluaran.dart';

class PengeluaranModel extends Pengeluaran {
  PengeluaranModel({
    required super.id,
    required super.createdAt,
    required super.namaPengeluaran,
    required super.jumlah,
    required super.tanggalPengeluaran,
    required super.kategoriPengeluaran,
    required super.buktiPengeluaran,
  });

  factory PengeluaranModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranModel(
      id: json['id'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
      namaPengeluaran: json['nama_pengeluaran'] as String,
      kategoriPengeluaran: json['kategori_pengeluaran'] as String,
      jumlah: (json['jumlah'] as num).toDouble(),
      tanggalPengeluaran: DateTime.parse(json['tanggal_pengeluaran'] as String),
      buktiPengeluaran: json['bukti_pengeluaran'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      // Jangan kirim 'id' saat insert, biarkan database auto-generate
      if (id != 0) 'id': id,
      'created_at': createdAt.toIso8601String(),
      'nama_pengeluaran': namaPengeluaran,
      'kategori_pengeluaran': kategoriPengeluaran,
      'bukti_pengeluaran': buktiPengeluaran,
      'jumlah': jumlah,
      'tanggal_pengeluaran': tanggalPengeluaran.toIso8601String(),
    };
  }
}
