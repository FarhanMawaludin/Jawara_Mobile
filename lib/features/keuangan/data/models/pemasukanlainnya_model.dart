import '../../domain/entities/pemasukanlainnya.dart';

class PemasukanLainnyaModel extends PemasukanLainnya {
  PemasukanLainnyaModel({
    required int id,
    required String namaPemasukan,
    required double kategoriPemasukan,
    required DateTime tanggalPemasukan,
    required double jumlah,
    required String buktiPemasukan,
  }) : super(
          id: id,
          namaPemasukan: namaPemasukan,
          kategoriPemasukan: kategoriPemasukan,
          tanggalPemasukan: tanggalPemasukan,
          jumlah: jumlah,
          buktiPemasukan: buktiPemasukan,
        );

  /// ===== JSON → MODEL =====
  factory PemasukanLainnyaModel.fromJson(Map<String, dynamic> json) {
    return PemasukanLainnyaModel(
      id: json['id'] as int,
      namaPemasukan: json['nama_pemasukan'] as String,
      kategoriPemasukan: (json['kategori_pemasukan'] as num).toDouble(),
      tanggalPemasukan: DateTime.parse(json['tanggal_pemasukan']),
      jumlah: (json['jumlah'] as num).toDouble(),
      buktiPemasukan: json['bukti_pemasukan'] as String,
    );
  }

  /// ===== MODEL → JSON =====
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_pemasukan': namaPemasukan,
      'kategori_pemasukan': kategoriPemasukan,
      'tanggal_pemasukan': tanggalPemasukan.toIso8601String(),
      'jumlah': jumlah,
      'bukti_pemasukan': buktiPemasukan,
    };
  }
}
