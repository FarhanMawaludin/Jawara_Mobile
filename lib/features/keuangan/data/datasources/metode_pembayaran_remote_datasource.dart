import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/metodepembayaran_model.dart';

class MetodePembayaranDatasource {
  final supabase = Supabase.instance.client;

  Future<List<MetodePembayaran>> getAll() async {
    final res = await supabase
        .from('metode_pembayaran')
        .select()
        .order('nama_metode');

    return res.map((e) => MetodePembayaran.fromJson(e)).toList();
  }

  Future<MetodePembayaran?> getById(int id) async {
    final res = await supabase
        .from('metode_pembayaran')
        .select()
        .eq('id', id)
        .maybeSingle();

    return res == null ? null : MetodePembayaran.fromJson(res);
  }

  Future<bool> insert(MetodePembayaran data) async {
    final res = await supabase
        .from('metode_pembayaran')
        .insert(data.toJson());

    return res != null;
  }

  Future<bool> update(MetodePembayaran data) async {
    final res = await supabase
        .from('metode_pembayaran')
        .update(data.toJson())
        .eq('id', data.id);

    return res != null;
  }

  Future<bool> delete(int id) async {
    final res =
        await supabase.from('metode_pembayaran').delete().eq('id', id);

    return res != null;
  }
}
