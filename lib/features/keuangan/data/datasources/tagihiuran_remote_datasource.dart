import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/tagihiuran_model.dart';

class TagihIuranRemoteDatasource {
  final supabase = Supabase.instance.client;

  // Get all tagihan
  Future<List<TagihIuranModel>> getAll() async {
    final response = await supabase.from('tagih_iuran').select();

    return response
        .map((e) => TagihIuranModel.fromJson(e))
        .toList();
  }

  // Get tagihan by ID
  Future<TagihIuranModel?> getById(int id) async {
    final response =
        await supabase.from('tagih_iuran').select().eq('id', id).maybeSingle();

    if (response == null) return null;

    return TagihIuranModel.fromJson(response);
  }


  Future<Map<String, dynamic>> insert(Map<String, dynamic> data) async {
    final response = await supabase
        .from('tagih_iuran')
        .insert(data)
        .select()
        .single();

    print('respone dari supabase: $response');
    return response;
  }

  // Get all keluarga IDs
  Future<List<int>> getAllKeluargaIds() async {
    final response = await supabase.from('keluarga').select('id');
    return (response as List).map((e) => e['id'] as int).toList();
  }

  // Update tagihan
  Future<bool> update(int id, TagihIuranModel data) async {
    final resp = await supabase
        .from('tagih_iuran')
        .update(data.toJson())
        .eq('id', id)
        .select();

    return resp.isNotEmpty;
  }

  // Delete tagihan
  Future<bool> delete(int id) async {
    final resp =
        await supabase.from('tagih_iuran').delete().eq('id', id).select();

    return resp.isNotEmpty;
  }

  Future<void> bulkInsertIuranDetail(List<Map<String, dynamic>> dataList) async {
    await supabase.from('iuran_detail').insert(dataList);
  }
}