import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kegiatan_form_model.dart';
import '../models/kegiatan_statistics_model.dart';

class KegiatanRepository {
  final SupabaseClient _supabase;

  KegiatanRepository(this._supabase);

  Future<Map<String, dynamic>> createKegiatan(KegiatanFormModel form) async {
    try {
      if (form.namaKegiatan.isEmpty) {
        return {
          'success': false,
          'message': 'Nama kegiatan wajib diisi',
        };
      }

      final data = {
        'nama_kegiatan': form.namaKegiatan.trim(),
        'kategori_kegiatan': form.kategori.toLowerCase(), // FIX: kategori, bukan kategoriKegiatan
        'tanggal_kegiatan': form.tanggalKegiatan?.toIso8601String(),
        'lokasi_kegiatan': form.lokasi.trim(), // FIX: lokasi, bukan lokasiKegiatan
        'penanggung_jawab_kegiatan': form.penanggungJawab.trim(), // FIX: penanggungJawab, bukan penanggungJawabKegiatan
        'deskripsi_kegiatan': form.deskripsi.trim(), // FIX: deskripsi, bukan deskripsiKegiatan
      };

      print('DEBUG: Sending data to Supabase: $data');

      final response = await _supabase
          .from('kegiatan')
          .insert(data)
          .select()
          .single();

      print('DEBUG: Response from Supabase: $response');

      if (response != null && response['id'] != null) {
        return {
          'success': true,
          'message': 'Kegiatan berhasil ditambahkan',
          'data': response,
        };
      } else {
        return {
          'success': false,
          'message': 'Data tersimpan tapi response tidak valid',
        };
      }
    } on PostgrestException catch (e) {
      print('ERROR PostgrestException:');
      print('  Message: ${e.message}');
      print('  Code: ${e.code}');
      print('  Details: ${e.details}');
      print('  Hint: ${e.hint}');

      if (e.code == '23502') {
        return {
          'success': false,
          'message': 'Kolom wajib tidak boleh kosong',
        };
      }

      return {
        'success': false,
        'message': 'Database error: ${e.message}',
      };
    } catch (e, stackTrace) {
      print('ERROR General: $e');
      print('Stack Trace: $stackTrace');

      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getKegiatanList() async {
    try {
      final response = await _supabase
          .from('kegiatan')
          .select()
          .order('tanggal_kegiatan', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('ERROR getKegiatanList: $e');
      throw Exception('Gagal mengambil data kegiatan: $e');
    }
  }

  Future<Map<String, dynamic>> deleteKegiatan(int id) async {
    try {
      await _supabase.from('kegiatan').delete().eq('id', id);

      return {
        'success': true,
        'message': 'Kegiatan berhasil dihapus',
      };
    } catch (e) {
      print('ERROR deleteKegiatan: $e');
      return {
        'success': false,
        'message': 'Gagal menghapus kegiatan: $e',
      };
    }
  }

  Future<Map<String, dynamic>?> getKegiatanById(int id) async {
    try {
      final response = await _supabase
          .from('kegiatan')
          .select()
          .eq('id', id)
          .single();

      return response;
    } catch (e) {
      print('ERROR getKegiatanById: $e');
      return null;
    }
  }

  Future<KegiatanStatisticsModel> getStatistics() async {
    try {
      final kegiatanList = await getKegiatanList();
      
      if (kegiatanList.isEmpty) {
        return KegiatanStatisticsModel.empty();
      }

      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);

      int selesai = 0;
      int hariIni = 0;
      int akanDatang = 0;

      for (var kegiatan in kegiatanList) {
        final tanggalStr = kegiatan['tanggal_kegiatan'];
        
        if (tanggalStr == null) {
          continue;
        }

        try {
          final tanggalKegiatan = DateTime.parse(tanggalStr);
          final kegiatanDate = DateTime(
            tanggalKegiatan.year,
            tanggalKegiatan.month,
            tanggalKegiatan.day,
          );

          if (kegiatanDate.isBefore(today)) {
            selesai++;
          } else if (kegiatanDate.isAtSameMomentAs(today)) {
            hariIni++;
          } else {
            akanDatang++;
          }
        } catch (e) {
          print('ERROR parsing date: $e');
          continue;
        }
      }

      return KegiatanStatisticsModel(
        totalKegiatan: kegiatanList.length,
        selesai: selesai,
        hariIni: hariIni,
        akanDatang: akanDatang,
      );
    } catch (e) {
      print('ERROR getStatistics: $e');
      return KegiatanStatisticsModel.empty();
    }
  }
}
