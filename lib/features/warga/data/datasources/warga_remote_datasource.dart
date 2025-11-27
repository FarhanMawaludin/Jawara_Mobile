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
      final List<dynamic> data = await client.from('warga').select('''
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
        ''')
          .eq('role_keluarga', 'kepala_keluarga');

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
    try {
      await client
          .from('warga')
          .update(warga.toMap())
          .eq('id', warga.id)
          .select();
    } catch (e) {
      throw Exception("Gagal update warga: $e");
    }
  }

  @override
  Future<void> deleteWarga(int id) async {
    // 1. Ambil data warga yang mau dihapus
    final data = await client
        .from('warga')
        .select('id, role_keluarga, keluarga_id')
        .eq('id', id)
        .maybeSingle();

    if (data == null) {
      throw Exception("Warga tidak ditemukan");
    }

    final role = data['role_keluarga'] as String?;
    final keluargaId = data['keluarga_id'] as int?;

    // Validasi role
    if (role == null) {
      throw Exception("role_keluarga null");
    }

    // Jika kepala keluarga → hapus keluarga + semua anggota
    if (role == 'kepala_keluarga') {
      if (keluargaId == null) {
        throw Exception("keluarga_id null untuk kepala keluarga");
      }

      // 1. Hapus semua anggota keluarga
      await client.from('warga').delete().eq('keluarga_id', keluargaId);

      // 2. Hapus data keluarga di tabel keluarga
      await client.from('keluarga').delete().eq('id', keluargaId);
    }
    // Jika bukan kepala keluarga → hanya hapus satu orang
    else {
      await client.from('warga').delete().eq('id', id);
    }
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
          .ilike('nama', '%$keyword%');

      return data.map((json) => WargaModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mencari warga: $e");
    }
  }

  @override
  Future<List<WargaModel>> getWargaByKeluargaId(int keluargaId) async {
    final result = await client
        .from('warga')
        .select('*, keluarga(*), rumah(*)')
        .eq('keluarga_id', keluargaId);

    return result.map((e) => WargaModel.fromMap(e)).toList();
  }
}
