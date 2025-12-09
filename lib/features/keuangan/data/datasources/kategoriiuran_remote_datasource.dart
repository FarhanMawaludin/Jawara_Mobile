import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/kategoriiuran_model.dart';

class KategoriIuranDatasource {
  final SupabaseClient supabase = Supabase.instance.client;

  // -----------------------------
  // GET ALL
  // -----------------------------
  Future<List<KategoriIuran>> getAll() async {
    final response = await supabase
        .from('kategori_iuran')
        .select()
        .order('id', ascending: true);

    return response
        .map<KategoriIuran>((json) => KategoriIuran.fromJson(json))
        .toList();
  }

  // -----------------------------
  // GET BY ID
  // -----------------------------
  Future<KategoriIuran?> getById(int id) async {
    final response = await supabase
        .from('kategori_iuran')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return KategoriIuran.fromJson(response);
  }

  // -----------------------------
  // CREATE
  // -----------------------------
  Future<KategoriIuran?> create(KategoriIuran data) async {
    try {
      final response = await supabase
          .from('kategori_iuran')
          .insert(data.toJson())
          .select()
          .single();

      return KategoriIuran.fromJson(response);
    } catch (e) {
      return null;
    }
  }

  // -----------------------------
  // UPDATE
  // -----------------------------
  Future<KategoriIuran?> update(int id, KategoriIuran data) async {
    try {
      final response = await supabase
          .from('kategori_iuran')
          .update(data.toJson())
          .eq('id', id)
          .select()
          .maybeSingle();

      if (response == null) return null;
      return KategoriIuran.fromJson(response);
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
