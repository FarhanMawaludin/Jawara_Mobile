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

      if (form.anggaran < 0) {
        return {
          'success': false,
          'message': 'Anggaran tidak boleh negatif',
        };
      }

      // ✅ 1. SIMPAN KEGIATAN DULU
      final kegiatanData = {
        'nama_kegiatan': form.namaKegiatan.trim(),
        'kategori_kegiatan': form.kategori.toLowerCase(),
        'tanggal_kegiatan': form.tanggalKegiatan?.toIso8601String(),
        'lokasi_kegiatan': form.lokasi.trim(),
        'penanggung_jawab_kegiatan': form.penanggungJawab.trim(),
        'deskripsi_kegiatan': form.deskripsi.trim(),
      };

      final kegiatanResponse = await _supabase
          .from('kegiatan')
          .insert(kegiatanData)
          .select()
          .single();

      if (kegiatanResponse == null || kegiatanResponse['id'] == null) {
        return {
          'success': false,
          'message': 'Gagal menyimpan kegiatan',
        };
      }

      final kegiatanId = kegiatanResponse['id'] as int;
      bool pengeluaranCreated = false;
      int? pengeluaranId;
      String? pengeluaranError;

      // ✅ 2. BUAT PENGELUARAN LANGSUNG KE DATABASE JIKA ADA ANGGARAN
      if (form.anggaran > 0) {
        try {
          final tanggalPengeluaran = form.tanggalKegiatan ?? DateTime.now();
          
          final pengeluaranData = {
            'created_at': DateTime.now().toIso8601String(),
            'nama_pengeluaran': form.namaKegiatan.trim(),
            'kategori_pengeluaran': 'Kegiatan Warga',
            'tanggal_pengeluaran': tanggalPengeluaran.toIso8601String(),
            'jumlah': form.anggaran,
            'bukti_pengeluaran': '',
            'kegiatan_id': kegiatanId, // ✅ TAMBAHKAN: Link ke kegiatan
          };

          print('📤 Inserting pengeluaran: $pengeluaranData');

          final pengeluaranResponse = await _supabase
              .from('pengeluaran')
              .insert(pengeluaranData)
              .select()
              .single();

          pengeluaranId = pengeluaranResponse['id'] as int;
          print('✅ Pengeluaran created: $pengeluaranId');
          
          pengeluaranCreated = true;
        } catch (e) {
          pengeluaranError = e.toString();
          print('❌ Error creating pengeluaran: $e');
        }
      }

      return {
        'success': true,
        'message': _buildSuccessMessage(form.anggaran, pengeluaranCreated),
        'data': kegiatanResponse,
        'kegiatan_id': kegiatanId,
        'pengeluaran_created': pengeluaranCreated,
        'pengeluaran_id': pengeluaranId, // ✅ TAMBAHKAN: Return pengeluaran ID
        if (pengeluaranError != null) 'pengeluaran_error': pengeluaranError,
      };
    } on PostgrestException catch (e) {
      print('❌ PostgrestException: ${e.code} - ${e.message}');
      
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
      print('❌ Exception: $e');
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }

  String _buildSuccessMessage(double anggaran, bool pengeluaranCreated) {
    if (anggaran > 0) {
      if (pengeluaranCreated) {
        return 'Kegiatan berhasil ditambahkan dan anggaran tercatat sebagai pengeluaran';
      } else {
        return 'Kegiatan berhasil ditambahkan (anggaran gagal dicatat)';
      }
    }
    return 'Kegiatan berhasil ditambahkan';
  }

  // ✅ TAMBAHKAN: Method untuk get anggaran berdasarkan kegiatan_id
  Future<double> getAnggaranByKegiatanId(int kegiatanId) async {
    try {
      final response = await _supabase
          .from('pengeluaran')
          .select('jumlah')
          .eq('kegiatan_id', kegiatanId)
          .maybeSingle();

      if (response == null) return 0.0;

      return (response['jumlah'] as num).toDouble();
    } catch (e) {
      print('Error getting anggaran for kegiatan #$kegiatanId: $e');
      return 0.0;
    }
  }

  Future<double> getTotalAnggaranKegiatan() async {
    try {
      final response = await _supabase
          .from('pengeluaran')
          .select('jumlah')
          .eq('kategori_pengeluaran', 'Kegiatan Warga');

      if (response.isEmpty) return 0.0;

      double total = 0;
      for (var item in response) {
        total += (item['jumlah'] as num).toDouble();
      }
      return total;
    } catch (e) {
      print('Error getting total anggaran kegiatan: $e');
      return 0.0;
    }
  }

  Future<double> getAnggaranKegiatan(String namaKegiatan) async {
    try {
      final response = await _supabase
          .from('pengeluaran')
          .select('jumlah')
          .eq('nama_pengeluaran', namaKegiatan)
          .eq('kategori_pengeluaran', 'Kegiatan Warga')
          .maybeSingle();

      if (response == null) return 0.0;

      return (response['jumlah'] as num).toDouble();
    } catch (e) {
      print('Error getting anggaran for $namaKegiatan: $e');
      return 0.0;
    }
  }

  Future<List<Map<String, dynamic>>> getPengeluaranKegiatan() async {
    try {
      final response = await _supabase
          .from('pengeluaran')
          .select()
          .eq('kategori_pengeluaran', 'Kegiatan Warga')
          .order('tanggal_pengeluaran', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error getting pengeluaran kegiatan: $e');
      return [];
    }
  }

  // ✅ UPDATE: Delete kegiatan juga hapus pengeluaran terkait (jika ON DELETE CASCADE tidak diset)
  Future<Map<String, dynamic>> deleteKegiatan(int id) async {
    try {
      // Opsional: Hapus pengeluaran terkait dulu jika tidak pakai CASCADE
      // await _supabase.from('pengeluaran').delete().eq('kegiatan_id', id);
      
      // Hapus kegiatan (CASCADE akan auto-hapus pengeluaran)
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
