import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/iurandetail_model.dart';

class IuranDetailDatasource {
  final supabase = Supabase.instance.client;

  Future<List<IuranDetail>> getByKeluarga(int keluargaId) async {
    final res = await supabase
        .from('iuran_detail')
        .select('*, tagih_iuran(*)')
        .eq('keluarga_id', keluargaId);

    return (res as List)
        .map((e) => IuranDetail.fromJson(e))
        .toList();
  }

  Future<void> insert(IuranDetail data) async {
    await supabase.from('iuran_detail').insert(data.toJson());
  }

  Future<void> update(IuranDetail data) async {
    await supabase
        .from('iuran_detail')
        .update(data.toJson())
        .eq('id', data.id);
  }

  Future<void> delete(int id) async {
    await supabase.from('iuran_detail').delete().eq('id', id);
  }
}
