import '../../domain/entities/pengeluaran.dart';

class PengeluaranModel extends Pengeluaran {
  PengeluaranModel({
    required super.id,
    required super.namaPengeluaran,
    required super.jumlah,
    required super.tanggalPengeluaran,
    required super.kategoriPengeluaran,
    required super.buktiPengeluaran,
  });

  factory PengeluaranModel.fromJson(Map<String, dynamic> json) {
    return PengeluaranModel(
      id: json['id'],
      namaPengeluaran: json['nama'],
      kategoriPengeluaran: (json['kategori'] as num).toDouble(),
      jumlah: (json['jumlah'] as num).toDouble(),
      tanggalPengeluaran: DateTime.parse(json['tanggal']),
      buktiPengeluaran: json['bukti pengeluaran'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': namaPengeluaran,
      'kategori': kategoriPengeluaran,
      'bukti': buktiPengeluaran,
      'jumlah': jumlah,
      'tanggal': tanggalPengeluaran.toIso8601String(),
      'bukti pengeluaran': buktiPengeluaran,
    };
  }
}
