class IuranDetail {
  final int id;
  final int keluargaId;
  final int tagihIuranId;
  final int metodePembayaranId;

  IuranDetail({
    required this.id,
    required this.keluargaId,
    required this.tagihIuranId,
    required this.metodePembayaranId,
  });

  factory IuranDetail.fromJson(Map<String, dynamic> json) {
    return IuranDetail(
      id: json['id'],
      keluargaId: json['keluarga_id'],
      tagihIuranId: json['tagih_iuran_id'],
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
