import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pemasukanlainnya_model.dart';

class PemasukanLainnyaDatasource {
  final supabase = Supabase.instance.client;

  Future<List<PemasukanLainnyaModel>> getAll() async {
    final res = await supabase
        .from('pemasukan_lainnya')
        .select()
        .order('tanggal_pemasukan', ascending: false);

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
