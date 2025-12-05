import 'dart:io';
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
        'kategori_kegiatan': form.kategori.toLowerCase(),
        'tanggal_kegiatan': form.tanggalKegiatan?.toIso8601String(),
        'lokasi_kegiatan': form.lokasi.trim(),
        'penanggung_jawab_kegiatan': form.penanggungJawab.trim(),
        'deskripsi_kegiatan': form.deskripsi.trim(),
      };

      final response = await _supabase
          .from('kegiatan')
          .insert(data)
          .select()
          .single();

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
    } on SocketException catch (_) {
      return {
        'success': false,
        'message': 'Tidak ada koneksi internet',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  Future<List<Map<String, dynamic>>> getKegiatanList({
    int limit = 10,
    int offset = 0,
  }) async {
    try {
      final response = await _supabase
          .from('kegiatan')
          .select()
          .order('tanggal_kegiatan', ascending: false)
          .range(offset, offset + limit - 1);

      return List<Map<String, dynamic>>.from(response);
    } on SocketException catch (_) {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
      throw Exception('Gagal mengambil data kegiatan: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getAllKegiatan() async {
    try {
      final response = await _supabase
          .from('kegiatan')
          .select()
          .order('tanggal_kegiatan', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } on SocketException catch (_) {
      throw Exception('Tidak ada koneksi internet');
    } catch (e) {
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
    } on SocketException catch (_) {
      return {
        'success': false,
        'message': 'Tidak ada koneksi internet',
      };
    } catch (e) {
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
    } on SocketException catch (_) {
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<KegiatanStatisticsModel> getStatistics() async {
    try {
      final kegiatanList = await getAllKegiatan();
      
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
        if (tanggalStr == null) continue;

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
        } catch (_) {
          continue;
        }
      }

      return KegiatanStatisticsModel(
        totalKegiatan: kegiatanList.length,
        selesai: selesai,
        hariIni: hariIni,
        akanDatang: akanDatang,
      );
    } on SocketException catch (_) {
      return KegiatanStatisticsModel.empty();
    } catch (e) {
      return KegiatanStatisticsModel.empty();
    }
  }
}
