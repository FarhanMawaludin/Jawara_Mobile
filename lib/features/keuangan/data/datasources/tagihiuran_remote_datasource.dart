import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tagihiuran_model.dart';

class TagihIuranRemoteDatasource {
  final supabase = Supabase.instance.client;

  Future<List<TagihIuranModel>> getAll() async {
    final response = await supabase.from('tagih_iuran').select();

    return response
        .map((e) => TagihIuranModel.fromJson(e))
        .toList();
  }

  Future<TagihIuranModel?> getById(int id) async {
    final response =
        await supabase.from('tagih_iuran').select().eq('id', id).maybeSingle();

    if (response == null) return null;

    return TagihIuranModel.fromJson(response);
  }

  Future<List<TagihIuranModel>> getByKeluarga(int keluargaId) async {
    final response = await supabase
        .from('tagih_iuran')
        .select()
        .eq('keluarga_id', keluargaId);

    return response.map((e) => TagihIuranModel.fromJson(e)).toList();
  }

  Future<bool> create(TagihIuranModel data) async {
    final resp =
        await supabase.from('tagih_iuran').insert(data.toJson()).select();

    return resp.isNotEmpty;
  }

  Future<bool> update(int id, TagihIuranModel data) async {
    final resp = await supabase
        .from('tagih_iuran')
        .update(data.toJson())
        .eq('id', id)
        .select();

    return resp.isNotEmpty;
  }

  Future<bool> delete(int id) async {
    final resp =
        await supabase.from('tagih_iuran').delete().eq('id', id).select();

    return resp.isNotEmpty;
  }
}
