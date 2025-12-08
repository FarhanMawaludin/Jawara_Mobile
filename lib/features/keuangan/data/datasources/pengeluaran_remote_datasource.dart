import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/pengeluaran_model.dart';

class PengeluaranRemoteDatasource {
  final supabase = Supabase.instance.client;

  Future<List<PengeluaranModel>> getAll() async {
    final res = await supabase
        .from('pengeluaran')
        .select()
        .order('tanggal', ascending: false);

    return (res as List)
        .map((e) => PengeluaranModel.fromJson(e))
        .toList();
  }

  Future<PengeluaranModel?> getById(int id) async {
    final res = await supabase
        .from('pengeluaran')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (res == null) return null;
    return PengeluaranModel.fromJson(res);
  }

  Future<void> insert(PengeluaranModel data) async {
    await supabase.from('pengeluaran').insert(data.toJson());
  }

  Future<void> update(PengeluaranModel data) async {
    await supabase
        .from('pengeluaran')
        .update(data.toJson())
        .eq('id', data.id);
  }

  Future<void> delete(int id) async {
    await supabase.from('pengeluaran').delete().eq('id', id);
  }
}
