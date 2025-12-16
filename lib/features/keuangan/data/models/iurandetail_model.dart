import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';

class IuranDetail {
  final int id;
  final DateTime createdAt;
  final int keluargaId;
  final int tagihIuran; // ✅ UBAH:  Ini adalah ID, bukan object
  final int?  metodePembayaranId;
  final TagihIuran?  tagihIuranData; // ✅ UBAH: Ini adalah nested object dari join

  IuranDetail({
    required this.id,
    required this.createdAt,
    required this.keluargaId,
    required this.tagihIuran,
    this. metodePembayaranId,
    this.tagihIuranData,
  });

  factory IuranDetail.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 [IuranDetail. fromJson] Parsing:  $json');
      
      // Parse nested tagih_iuran dari join query
      TagihIuran? parsedTagihIuran;
      if (json. containsKey('tagih_iuran') && json['tagih_iuran'] is Map) {
        try {
          final tagihIuranJson = json['tagih_iuran'] as Map<String, dynamic>;
          print('🔍 [IuranDetail] Parsing nested tagih_iuran');
          parsedTagihIuran = TagihIuran.fromJson(tagihIuranJson);
          print('✅ [IuranDetail] Successfully parsed tagih_iuran');
        } catch (e, st) {
          print('❌ [IuranDetail] Error parsing tagih_iuran: $e');
          print('📍 StackTrace: $st');
        }
      }
      
      final result = IuranDetail(
        id: json['id'] as int,
        createdAt: DateTime.parse(json['created_at'] as String),
        keluargaId: json['keluarga_id'] as int,
        tagihIuran: json['tagih_iuran'] is int 
            ? json['tagih_iuran'] as int
            : (json['tagih_iuran'] as Map<String, dynamic>)['id'] as int, // ✅ Ambil ID dari nested object
        metodePembayaranId: json['metode_pembayaran_id'] as int?,
        tagihIuranData: parsedTagihIuran,
      );
      
      print('✅ [IuranDetail. fromJson] Success - ID: ${result.id}, Tagihan: ${result.tagihIuranData?.nama}');
      return result;
      
    } catch (e, st) {
      print('❌ [IuranDetail.fromJson] Error: $e');
      print('📍 Failed JSON: $json');
      print('📍 StackTrace:  $st');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'keluarga_id': keluargaId,
      'tagih_iuran': tagihIuran,
      if (metodePembayaranId != null)
        'metode_pembayaran_id': metodePembayaranId,
    };
  }

  Map<String, dynamic> toJsonForInsert() {
    return {
      'keluarga_id': keluargaId,
      'tagih_iuran': tagihIuran,
      if (metodePembayaranId != null)
        'metode_pembayaran_id': metodePembayaranId,
    };
  }

  // ✅ Helper:  Get status dari tagih_iuran nested
  String get statusPembayaran {
    return tagihIuranData?.statusTagihan ?? 'belum_bayar';
  }

  // ✅ Helper: Get tanggal bayar dari tagih_iuran nested
  DateTime?  get tanggalPembayaran {
    return tagihIuranData?.tanggalBayar;
  }
}