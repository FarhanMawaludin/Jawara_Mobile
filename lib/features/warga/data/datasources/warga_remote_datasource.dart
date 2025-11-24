import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/warga_model.dart';

abstract class WargaRemoteDataSource {
  Future<List<WargaModel>> getAllWarga();
  Future<List<WargaModel>> getAllKeluarga();
  Future<WargaModel?> getWargaById(int id);
  Future<void> createWarga(WargaModel warga);
  Future<void> updateWarga(WargaModel warga);
  Future<void> deleteWarga(int id);
  Future<List<WargaModel>> searchWarga(String keyword);
  Future<List<WargaModel>> getWargaByKeluargaId(int keluargaId); 
}

class WargaRemoteDataSourceImpl implements WargaRemoteDataSource {
  final SupabaseClient client;

  WargaRemoteDataSourceImpl(this.client);

  @override
  Future<List<WargaModel>> getAllWarga() async {
    try {
      final List<dynamic> data = await client
          .from('warga')
          .select('''
          *,
          keluarga:keluarga_id (
            id,
            nama_keluarga
          ),
          rumah:alamat_rumah_id (
            id,
            alamat_lengkap,
            blok,
            nomor_rumah
          )
        '''); 

      print(data);

      return data.map((json) => WargaModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data Warga: $e");
    }
  }

   @override
  Future<List<WargaModel>> getAllKeluarga() async {
    try {
      final List<dynamic> data = await client
          .from('warga')
          .select('''
          *,
          keluarga:keluarga_id (
            id,
            nama_keluarga
          ),
          rumah:alamat_rumah_id (
            id,
            alamat_lengkap,
            blok,
            nomor_rumah
          )
        ''').
          eq('role_keluarga', 'kepala_keluarga'); 

      print(data);

      return data.map((json) => WargaModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data Warga: $e");
    }
  }

  @override
  Future<WargaModel?> getWargaById(int id) async {
    try {
      final data = await client
          .from('warga')
          .select('''
          *,
          keluarga:keluarga_id (
            id,
            nama_keluarga
          ),
          alamat_rumah:alamat_rumah_id (
            id,
            alamat_lengkap,
            blok,
            nomor_rumah
          )
        ''')
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;

      return WargaModel.fromMap(data);
    } catch (e) {
      throw Exception("Gagal mengambil detail Warga: $e");
    }
  }

  @override
  Future<void> createWarga(WargaModel warga) async {
    final response = await client.from('warga').insert(warga.toMap());
    if (response.error != null) throw response.error!;
  }

  @override
  Future<void> updateWarga(WargaModel warga) async {
    final response = await client
        .from('warga')
        .update(warga.toMap())
        .eq('id', warga.id); // Hapus

    if (response.error != null) throw response.error!;
  }

  @override
  Future<void> deleteWarga(int id) async {
    final response = await client.from('warga').delete().eq('id', id);
    if (response.error != null) throw response.error!;
  }

  @override
  Future<List<WargaModel>> searchWarga(String keyword) async {
    try {
      final List<dynamic> data = await client
          .from('warga')
          .select('''
          *,
          keluarga:keluarga_id (
            id,
            nama_keluarga
          ),
          rumah:alamat_rumah_id (
            id,
            alamat_lengkap,
            blok,
            nomor_rumah
          )
        ''')
          .ilike('nama', '%$keyword%'); // search by nama (case-insensitive)

      return data.map((json) => WargaModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mencari warga: $e");
    }
  }

  Future<List<WargaModel>> getWargaByKeluargaId(int keluargaId) async {
    final result = await client
        .from('warga')
        .select('*, keluarga(*), rumah(*)')
        .eq('keluarga_id', keluargaId);

    return result.map((e) => WargaModel.fromMap(e)).toList();
  }
}
