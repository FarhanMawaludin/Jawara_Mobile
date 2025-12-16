import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/broadcast_form_model.dart';
import 'package:path/path.dart' as path;

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

  /// Upload file to Supabase Storage
  Future<String?> _uploadFile({
    required String filePath,
    required String bucketName,
    required String folder,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        print('❌ File tidak ditemukan: $filePath');
        return null;
      }

      // Generate unique filename with timestamp
      final fileExtension = path.extension(filePath);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}$fileExtension';
      final storagePath = '$folder/$fileName';

      print('📤 Uploading file: $fileName to $bucketName/$storagePath');

      // Read file as bytes
      final fileBytes = await file.readAsBytes();

      // Upload to Supabase Storage
      await _supabase.storage.from(bucketName).uploadBinary(
            storagePath,
            fileBytes,
            fileOptions: FileOptions(
              upsert: false,
              contentType: _getContentType(fileExtension),
            ),
          );

      // Get public URL
      final publicUrl = _supabase.storage.from(bucketName).getPublicUrl(storagePath);

      print('✅ File uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Error uploading file: $e');
      return null;
    }
  }

  /// Get content type based on file extension
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.xls':
        return 'application/vnd.ms-excel';
      case '.xlsx':
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
      case '.txt':
        return 'text/plain';
      default:
        return 'application/octet-stream';
    }
  }

  /// Delete file from Supabase Storage
  Future<void> _deleteFile(String fileUrl, String bucketName) async {
    try {
      // Extract file path from public URL
      final uri = Uri.parse(fileUrl);
      final pathSegments = uri.pathSegments;
      
      // Find the index of bucket name in path
      final bucketIndex = pathSegments.indexOf(bucketName);
      if (bucketIndex != -1 && bucketIndex < pathSegments.length - 1) {
        // Get path after bucket name
        final filePath = pathSegments.sublist(bucketIndex + 1).join('/');
        
        print('🗑️ Deleting file: $filePath from $bucketName');
        await _supabase.storage.from(bucketName).remove([filePath]);
        print('✅ File deleted successfully');
      }
    } catch (e) {
      print('❌ Error deleting file: $e');
    }
  }

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

      // Upload foto if exists
      if (form.fotoPath != null) {
        print('📸 Uploading foto...');
        fotoUrl = await _uploadFile(
          filePath: form.fotoPath!,
          bucketName: 'broadcast_images', // Sesuaikan dengan bucket di Supabase
          folder: 'photos',
        );

        if (fotoUrl == null) {
          return {
            'success': false,
            'message': 'Gagal mengupload foto. Periksa koneksi internet Anda.',
          };
        }
      }

      // Upload dokumen if exists
      if (form.dokumenPath != null) {
        print('📄 Uploading dokumen...');
        dokumenUrl = await _uploadFile(
          filePath: form.dokumenPath!,
          bucketName: 'broadcast_documents', // Sesuaikan dengan bucket di Supabase
          folder: 'documents',
        );

        if (dokumenUrl == null) {
          // Rollback: delete uploaded foto if dokumen upload fails
          if (fotoUrl != null) {
            await _deleteFile(fotoUrl, 'broadcast_images');
          }
          
          return {
            'success': false,
            'message': 'Gagal mengupload dokumen. Periksa koneksi internet Anda.',
          };
        }
      }

      final data = {
        'judul_broadcast': form.judul.trim(),
        'isi_broadcast': form.isi.trim(),
        'foto_broadcast': fotoUrl,
        'dokumen_broadcast': dokumenUrl,
      };

      print('📤 Sending data to Supabase: $data');

      final response = await _supabase
          .from('broadcast')
          .insert(data)
          .select()
          .single();

      print('✅ Broadcast created: ${response['id']}');

      if (response != null && response['id'] != null) {
        return {
          'success': true,
          'message': 'Broadcast berhasil dikirim',
          'data': response,
        };
      } else {
        // Rollback: delete uploaded files if database insert fails
        if (fotoUrl != null) {
          await _deleteFile(fotoUrl, 'broadcast_images');
        }
        if (dokumenUrl != null) {
          await _deleteFile(dokumenUrl, 'broadcast_documents');
        }
        
        return {
          'success': false,
          'message': 'Data tersimpan tapi response tidak valid',
        };
      }

    } on PostgrestException catch (e) {
      print('❌ PostgrestException:');
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
      print('❌ General error: $e');
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
      print('❌ getBroadcastList error: $e');
      throw Exception('Gagal mengambil data broadcast: $e');
    }
  }

  // Delete broadcast (with files)
  Future<Map<String, dynamic>> deleteBroadcast(int id) async {
    try {
      // Get broadcast data first to get file URLs
      final broadcast = await _supabase
          .from('broadcast')
          .select()
          .eq('id', id)
          .single();

      // Delete files from storage if they exist
      if (broadcast['foto_broadcast'] != null) {
        await _deleteFile(broadcast['foto_broadcast'], 'broadcast_images');
      }
      
      if (broadcast['dokumen_broadcast'] != null) {
        await _deleteFile(broadcast['dokumen_broadcast'], 'broadcast_documents');
      }

      // Delete broadcast record
      await _supabase
          .from('broadcast')
          .delete()
          .eq('id', id);

      print('✅ Broadcast deleted: $id');

      return {
        'success': true,
        'message': 'Broadcast berhasil dihapus',
      };
    } catch (e) {
      print('❌ deleteBroadcast error: $e');
      return {
        'success': false,
        'message': 'Gagal menghapus broadcast: $e',
      };
    }
  }
}