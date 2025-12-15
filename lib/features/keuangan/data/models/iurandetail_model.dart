import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';

class IuranDetail {
  final int id;
  final int keluargaId;
  final int tagihIuranId;
  final String statusPembayaran; // enum dari Supabase
  final DateTime? tanggalPembayaran;
  final TagihIuran? tagihIuran;
  final int metodePembayaranId;

  IuranDetail({
    required this.id,
    required this.keluargaId,
    required this.tagihIuranId,
    this.statusPembayaran = 'belum_bayar',
    this.tanggalPembayaran,
    this.tagihIuran,
    required this.metodePembayaranId,
  });

  factory IuranDetail.fromJson(Map<String, dynamic> json) {
    return IuranDetail(
      id: json['id'],
      keluargaId: json['keluarga_id'],
      tagihIuranId: json['tagih_iuran_id'],
      statusPembayaran: json['status_pembayaran'],
      tanggalPembayaran: json['tanggal_pembayaran'] 
        != null ? DateTime.parse(json['tanggal_pembayaran']) 
        : null,
      tagihIuran: json['tagih_iuran'] 
        != null ? TagihIuran.fromJson(json['tagih_iuran'])  
        : null,
      metodePembayaranId: json['metode_pembayaran_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'keluarga_id': keluargaId,
      'tagih_iuran_id': tagihIuranId,
      'metode_pembayaran_id': metodePembayaranId,
    };
  }
}
