import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/broadcast_form_model.dart';

final supabaseProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final broadcastRepositoryProvider = Provider<BroadcastRepository>((ref) {
  return BroadcastRepository(ref.watch(supabaseProvider));
});

final broadcastListProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final repository = ref.watch(broadcastRepositoryProvider);
  return repository.getBroadcastList();
});

class BroadcastRepository {
  final SupabaseClient _supabase;

  BroadcastRepository(this._supabase);

  // Create new broadcast
  Future<Map<String, dynamic>> createBroadcast(BroadcastFormModel form) async {
    try {
      if (form.judul.isEmpty) {
        return {
          'success': false,
          'message': 'Judul broadcast wajib diisi',
        };
      }

      if (form.isi.isEmpty) {
        return {
          'success': false,
          'message': 'Isi broadcast wajib diisi',
        };
      }

      String? fotoUrl;
      String? dokumenUrl;

      if (form.fotoPath != null) {
        print('TODO: Upload foto - Path: ${form.fotoPath}');
      }

      if (form.dokumenPath != null) {
        print('TODO: Upload dokumen - Path: ${form.dokumenPath}');
      }

      final data = {
        'judul_broadcast': form.judul.trim(),
        'isi_broadcast': form.isi.trim(),
        'foto_broadcast': fotoUrl,
        'dokumen_broadcast': dokumenUrl,
      };

      print('DEBUG: Sending data to Supabase: $data');

      final response = await _supabase
          .from('broadcast')
          .insert(data)
          .select()
          .single();

      print('DEBUG: Response from Supabase: $response');

      if (response != null && response['id'] != null) {
        return {
          'success': true,
          'message': 'Broadcast berhasil dikirim',
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

  // Get all broadcasts
  Future<List<Map<String, dynamic>>> getBroadcastList() async {
    try {
      final response = await _supabase
          .from('broadcast')
          .select()
          .order('id', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('ERROR getBroadcastList: $e');
      throw Exception('Gagal mengambil data broadcast: $e');
    }
  }

  // Delete broadcast
  Future<Map<String, dynamic>> deleteBroadcast(int id) async {
    try {
      await _supabase
          .from('broadcast')
          .delete()
          .eq('id', id);

      return {
        'success': true,
        'message': 'Broadcast berhasil dihapus',
      };
    } catch (e) {
      print('ERROR deleteBroadcast: $e');
      return {
        'success': false,
        'message': 'Gagal menghapus broadcast: $e',
      };
    }
  }
}