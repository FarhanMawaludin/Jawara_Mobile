import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/metodepembayaran_model.dart';

class MetodePembayaranDatasource {
  final supabase = Supabase.instance.client;
  static const bucket = 'files';

  Future<List<MetodePembayaranModel>> getAll() async {
    final res = await supabase
        .from('metode_pembayaran')
        .select()
        .order('created_at', ascending: false);

    return (res as List)
        .map((e) => MetodePembayaranModel.fromJson(e))
        .toList();
  }

  Future<MetodePembayaranModel?> getById(int id) async {
    final res = await supabase
        .from('metode_pembayaran')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (res == null) return null;
    return MetodePembayaranModel.fromJson(res);
  }

  Future<String?> uploadBarcode(File? file) async {
    if (file == null) return null;

    final name =
        'metode_pembayaran/barcode_${DateTime.now().millisecondsSinceEpoch}.png';

    final bytes = await file.readAsBytes();

    await supabase.storage.from(bucket).uploadBinary(
          name,
          bytes,
          fileOptions: const FileOptions(upsert: false),
        );

    return supabase.storage.from(bucket).getPublicUrl(name);
  }

  // ===== CREATE AN ENTRY =====
  Future<void> create(MetodePembayaranModel data) async {
    final res = await supabase.from('metode_pembayaran').insert(data.toJson());

    print("RESULT INSERT: $data");
    print(res);
  }

  // ===== UPDATE =====
  Future<void> update(MetodePembayaranModel data) async {
    await supabase
        .from('metode_pembayaran')
        .update(data.toJson())
        .eq('id', data.id);
  }

  // ===== DELETE =====
  Future<void> delete(int id) async {
    await supabase.from('metode_pembayaran').delete().eq('id', id);
  }
}
