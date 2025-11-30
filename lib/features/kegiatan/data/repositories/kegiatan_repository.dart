import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kegiatan_form_model.dart';
import '../models/kegiatan_statistics_model.dart';

class KegiatanRepository {
  final SupabaseClient _supabase;

  KegiatanRepository(this._supabase);

  // Method untuk mendapatkan statistik kegiatan
  Future<KegiatanStatisticsModel> getStatistics() async {
    try {
      final today = DateTime.now();
      final todayStart = DateTime(today.year, today.month, today.day);
      final todayEnd = DateTime(today.year, today.month, today.day, 23, 59, 59);

      // Get semua kegiatan - HANYA ambil tanggal_kegiatan
      final allKegiatan = await _supabase
          .from('kegiatan')
          .select('tanggal_kegiatan')
          .order('tanggal_kegiatan', ascending: false);

      print('Debug: Total data dari Supabase: ${allKegiatan.length}'); // Debug log

      int totalKegiatan = allKegiatan.length;
      int selesai = 0;
      int hariIni = 0;
      int akanDatang = 0;

      for (var kegiatan in allKegiatan) {
        try {
          final tanggalKegiatanStr = kegiatan['tanggal_kegiatan'] as String?;
          
          if (tanggalKegiatanStr == null) continue;

          // Parse tanggal (format dari Supabase: 'YYYY-MM-DD')
          final tanggalKegiatan = DateTime.parse(tanggalKegiatanStr);

          print('Debug: Tanggal kegiatan: $tanggalKegiatan'); // Debug log

          // Hitung kegiatan yang sudah lewat (dianggap selesai)
          if (tanggalKegiatan.isBefore(todayStart)) {
            selesai++;
          }

          // Hitung kegiatan hari ini
          if (tanggalKegiatan.isAfter(todayStart.subtract(const Duration(seconds: 1))) && 
              tanggalKegiatan.isBefore(todayEnd)) {
            hariIni++;
          }

          // Hitung kegiatan yang akan datang (tanggal > hari ini)
          if (tanggalKegiatan.isAfter(todayEnd)) {
            akanDatang++;
          }
        } catch (e) {
          print('Error parsing tanggal: $e');
          continue;
        }
      }

      print('Debug Statistik: Total=$totalKegiatan, Selesai=$selesai, Hari Ini=$hariIni, Akan Datang=$akanDatang');

      return KegiatanStatisticsModel(
        totalKegiatan: totalKegiatan,
        selesai: selesai,
        hariIni: hariIni,
        akanDatang: akanDatang,
      );
    } catch (e) {
      print('Error getStatistics: $e');
      // Jika error, return data kosong
      return KegiatanStatisticsModel.empty();
    }
  }

  Future<Map<String, dynamic>> createKegiatan(KegiatanFormModel form) async {
    try {
      // Validasi tanggal
      if (form.tanggalKegiatan == null) {
        return {
          'success': false,
          'message': 'Tanggal kegiatan harus diisi',
        };
      }

      // Konversi kategori ke lowercase untuk match dengan enum di Supabase
      final kategoriLowercase = form.kategori.toLowerCase();

      final data = {
        'nama_kegiatan': form.namaKegiatan.trim(),
        'tanggal_kegiatan': form.tanggalKegiatan!.toIso8601String().split('T')[0],
        'lokasi_kegiatan': form.lokasi.trim(),
        'penanggung_jawab_kegiatan': form.penanggungJawab.trim(),
        'kategori_kegiatan': kategoriLowercase,
        'deskripsi_kegiatan': form.deskripsi.trim(),
      };

      await _supabase.from('kegiatan').insert(data);

      return {
        'success': true,
        'message': 'Kegiatan berhasil ditambahkan',
      };
    } on PostgrestException catch (e) {
      if (e.code == '22P02') {
        return {
          'success': false,
          'message': 'Kategori tidak valid. Silakan pilih kategori yang tersedia.',
        };
      }

      return {
        'success': false,
        'message': 'Database error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Method untuk get list kegiatan (opsional)
  Future<List<Map<String, dynamic>>> getKegiatanList() async {
    try {
      final response = await _supabase
          .from('kegiatan')
          .select()
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Gagal mengambil data kegiatan: $e');
    }
  }

  // Ambil detail kegiatan
  Future<Map<String, dynamic>?> getKegiatanById(int id) async {
    try {
      final response = await _supabase
          .from('kegiatan')
          .select()
          .eq('id', id)
          .single();

      return response;
    } catch (_) {
      return null;
    }
  }

  // Update kegiatan
  Future<Map<String, dynamic>> updateKegiatan(
      int id, KegiatanFormModel form) async {
    try {
      if (form.tanggalKegiatan == null) {
        return {
          'success': false,
          'message': 'Tanggal kegiatan harus diisi',
        };
      }

      final kategoriLowercase = form.kategori.toLowerCase();

      final data = {
        'nama_kegiatan': form.namaKegiatan.trim(),
        'tanggal_kegiatan': form.tanggalKegiatan!
            .toIso8601String()
            .split('T')[0],
        'lokasi_kegiatan': form.lokasi.trim(),
        'penanggung_jawab_kegiatan': form.penanggungJawab.trim(),
        'kategori_kegiatan': kategoriLowercase,
        'deskripsi_kegiatan': form.deskripsi.trim(),
      };

      await _supabase.from('kegiatan').update(data).eq('id', id);

      return {
        'success': true,
        'message': 'Kegiatan berhasil diperbarui',
      };
    } on PostgrestException catch (e) {
      return {
        'success': false,
        'message': 'Database error: ${e.message}',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Hapus kegiatan
  Future<Map<String, dynamic>> deleteKegiatan(int id) async {
    try {
      await _supabase.from('kegiatan').delete().eq('id', id);

      return {
        'success': true,
        'message': 'Kegiatan berhasil dihapus',
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}
