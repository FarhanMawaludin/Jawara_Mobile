import '../../domain/entities/pemasukanlainnya.dart';

class PemasukanLainnyaModel extends PemasukanLainnya {
  PemasukanLainnyaModel({
    required int id,
    required DateTime createdAt,
    required String namaPemasukan,
    required String kategoriPemasukan,
    required DateTime tanggalPemasukan,
    required double jumlah,
    required String buktiPemasukan,
  }) : super(
          id: id,
          createdAt: createdAt,
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
      createdAt: DateTime.parse(json['created_at'] as String),
      namaPemasukan: json['nama_pemasukan'] as String,
      kategoriPemasukan: json['kategori_pemasukan'] as String,
      tanggalPemasukan: DateTime.parse(json['tanggal_pemasukan'] as String),
      jumlah: (json['jumlah'] as num).toDouble(),
      buktiPemasukan: json['bukti_pemasukan'] as String? ?? '',
    );
  }

  /// ===== MODEL → JSON =====
  Map<String, dynamic> toJson() {
    return {
      // Jangan kirim 'id' saat insert, biarkan database auto-generate
      if (id != 0) 'id': id,
      'created_at': createdAt.toIso8601String(),
      'nama_pemasukan': namaPemasukan,
      'kategori_pemasukan': kategoriPemasukan,
      'tanggal_pemasukan': tanggalPemasukan.toIso8601String(),
      'jumlah': jumlah,
      'bukti_pemasukan': buktiPemasukan,
    };
  }
}
