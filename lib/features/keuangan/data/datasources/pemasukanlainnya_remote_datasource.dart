import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pemasukanlainnya_model.dart';

class PemasukanLainnyaDatasource {
  final supabase = Supabase.instance.client;
  static const String storageBucket = 'files'; // atau sesuai bucket Anda

  Future<List<PemasukanLainnyaModel>> getAll() async {
    final res = await supabase
        .from('pemasukan_lainnya')
        .select()
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => PemasukanLainnyaModel.fromJson(e))
        .toList();
  }

  Future<PemasukanLainnyaModel?> getById(int id) async {
    final res = await supabase
        .from('pemasukan_lainnya')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (res == null) return null;
    return PemasukanLainnyaModel.fromJson(res);
  }

  /// Upload bukti langsung ke Supabase Storage
  /// Bucket HARUS sudah dibuat di Supabase Console
  Future<String> uploadBukti(File file, String fileName) async {
    try {
      final fileBytes = await file.readAsBytes();
      final path = 'pemasukan_lainnya/$fileName';
      
      // Upload ke Supabase Storage
      await supabase.storage.from(storageBucket).uploadBinary(
        path,
        fileBytes,
        fileOptions: const FileOptions(upsert: false),
      );

      // Dapatkan public URL
      final publicUrl = supabase.storage
          .from(storageBucket)
          .getPublicUrl(path);

      print('✅ File uploaded successfully: $publicUrl');
      return publicUrl;
    } catch (e) {
      print('❌ Upload error: $e');
      rethrow; // Lempar error agar bisa di-handle di repository
    }
  }

  Future<void> insert(PemasukanLainnyaModel data) async {
    await supabase.from('pemasukan_lainnya').insert(data.toJson());
  }

  Future<void> update(PemasukanLainnyaModel data) async {
    await supabase
        .from('pemasukan_lainnya')
        .update(data.toJson())
        .eq('id', data.id);
  }

  Future<void> delete(int id) async {
    await supabase.from('pemasukan_lainnya').delete().eq('id', id);
  }
}
