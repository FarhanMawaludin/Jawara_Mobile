import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/iurandetail_model.dart';

class IuranDetailDatasource {
  final supabase = Supabase.instance.client;

 Future<List<IuranDetail>> getByKeluarga(int keluargaId) async {
  try {
    print('🔍 [Datasource] Querying iuran_detail for keluargaId: $keluargaId');
    
    final res = await supabase
        .from('iuran_detail')
        .select('''
          *,
          tagih_iuran (
            id,
            nama,
            jumlah,
            tanggal_tagihan,
            status_tagihan,
            kategori_id,
            created_at,
            bukti_bayar,
            tanggal_bayar
          )
        ''')
        .eq('keluarga_id', keluargaId)
        .order('id', ascending: false);

    print('✅ [Datasource] Raw response: ${res.length} records');
    
    if (res.isEmpty) {
      print('⚠️ [Datasource] No data found');
      return [];
    }

    print('📄 [Datasource] ==== FIRST RECORD FULL DATA ====');
    print(res.first);
    print('📄 [Datasource] ==================================');

    final result = <IuranDetail>[];
    
    for (var i = 0; i < res.length; i++) {
      try {
        final json = res[i] as Map<String, dynamic>;
        print('');
        print('🔄 [Datasource] ========== Parsing record $i ==========');
        print('📋 JSON: $json');
        
        final item = IuranDetail.fromJson(json);
        result.add(item);
        
        print('✅ [Datasource] Successfully parsed record $i');
        print('   - ID: ${item.id}');
        print('   - Tagihan: ${item.tagihIuranData?. nama ??  "null"}');
        print('================================================');
      } catch (e, st) {
        print('');
        print('❌❌❌ [Datasource] ERROR parsing record $i ❌❌❌');
        print('📍 Error: $e');
        print('📍 Failed JSON: ${res[i]}');
        print('📍 StackTrace: ');
        print(st);
        print('================================================');
        // ✅ JANGAN skip, rethrow untuk lihat error
        rethrow; // ✅ Ubah dari "skip" jadi "rethrow"
      }
    }
    
    return result;
  } catch (e, st) {
    print('❌ [Datasource] Error in getByKeluarga: $e');
    print('📍 StackTrace: $st');
    rethrow;
  }
}
  Future<void> insert(IuranDetail data) async {
    try {
      print('📤 [Datasource] Inserting:  ${data.toJson()}');
      await supabase. from('iuran_detail').insert(data.toJson());
      print('✅ [Datasource] Insert success');
    } catch (e) {
      print('❌ [Datasource] Insert error:  $e');
      rethrow;
    }
  }

  Future<void> update(IuranDetail data) async {
    try {
      print('📤 [Datasource] Updating id:  ${data.id}');
      await supabase
          .from('iuran_detail')
          .update(data.toJson())
          .eq('id', data.id);
      print('✅ [Datasource] Update success');
    } catch (e) {
      print('❌ [Datasource] Update error: $e');
      rethrow;
    }
  }

  Future<void> delete(int id) async {
    try {
      print('📤 [Datasource] Deleting id: $id');
      await supabase. from('iuran_detail').delete().eq('id', id);
      print('✅ [Datasource] Delete success');
    } catch (e) {
      print('❌ [Datasource] Delete error: $e');
      rethrow;
    }
  }
}