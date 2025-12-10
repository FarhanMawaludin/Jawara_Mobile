import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategoriiuran_model.dart';

class KategoriIuranDatasource {
  final SupabaseClient supabase = Supabase.instance.client;

  // -----------------------------
  // GET ALL
  // -----------------------------
  Future<List<KategoriIuranModel>> getAll() async {
    final response = await supabase
        .from('kategori_iuran')
        .select()
        .order('id', ascending: true);

    return response
        .map<KategoriIuranModel>((json) => KategoriIuranModel.fromJson(json))
        .toList();
  }

  // -----------------------------
  // GET BY ID
  // -----------------------------
  Future<KategoriIuranModel?> getById(int id) async {
    final response = await supabase
        .from('kategori_iuran')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return KategoriIuranModel.fromJson(response);
  }

  // -----------------------------
  // CREATE
  // -----------------------------
  Future<KategoriIuranModel?> create(KategoriIuranModel data) async {
    try {
      final response = await supabase
          .from('kategori_iuran')
          .insert(data.toJson())
          .select()
          .single();

      return KategoriIuranModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  Future<KategoriIuranModel?> update(int id, KategoriIuranModel data) async {
    try {
      final response = await supabase
          .from('kategori_iuran')
          .update(data.toJson())
          .eq('id', id)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return KategoriIuranModel.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  Future<bool> delete(int id) async {
    try {
      await supabase.from('kategori_iuran').delete().eq('id', id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
