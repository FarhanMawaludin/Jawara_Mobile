import '../../domain/entities/pengeluaran.dart';

class PengeluaranModel extends Pengeluaran {
  PengeluaranModel({
    required super.id,
    required super.nama,
    required super.jumlah,
    required super.tanggal,
    super.catatan,
  });

  factory PengeluaranModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranModel(
      id: json['id'],
      nama: json['nama'],
      jumlah: (json['jumlah'] as num).toDouble(),
      tanggal: DateTime.parse(json['tanggal']),
      catatan: json['catatan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'jumlah': jumlah,
      'tanggal': tanggal.toIso8601String(),
      'catatan': catatan,
    };
  }
}
