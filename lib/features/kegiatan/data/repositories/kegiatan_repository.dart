import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kegiatan_form_model.dart';

class KegiatanRepository {
  final SupabaseClient _supabase;

  KegiatanRepository(this._supabase);

  Future<Map<String, dynamic>> createKegiatan(KegiatanFormModel form) async {
    try {
      // Validasi sederhana
      if (form.tanggalKegiatan == null) {
        return {
          'success': false,
          'message': 'Tanggal kegiatan harus diisi',
        };
      }

      // Samakan format kategori
      final kategoriLowercase = form.kategori.toLowerCase();

      // Payload insert
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

      await _supabase.from('kegiatan').insert(data);

      return {
        'success': true,
        'message': 'Kegiatan berhasil ditambahkan',
      };
    } on PostgrestException catch (e) {
      // Error dari Postgres
      if (e.code == '22P02') {
        return {
          'success': false,
          'message': 'Kategori tidak valid.',
        };
      }
      return {
        'success': false,
        'message': 'Database error: ${e.message}',
      };
    } catch (e) {
      // Error umum
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  // Ambil semua kegiatan
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
