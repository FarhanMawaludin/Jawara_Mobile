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

  /// Mengambil statistik warga dari backend (RPC) atau fallback ke perhitungan client-side.
  Future<Map<String, dynamic>> getStatistikWarga();
  Future<int> countKeluarga();
  Future<int> countWarga();
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

  @override
  Future<Map<String, dynamic>> getStatistikWarga() async {
    try {
      // Coba panggil RPC di database terlebih dahulu
      final rpcResp = await client.rpc('get_statistik_warga');

      if (rpcResp != null) {
        // Beberapa RPC mengembalikan list dengan single object
        if (rpcResp is List && rpcResp.isNotEmpty) {
          return Map<String, dynamic>.from(rpcResp.first as Map);
        }

        if (rpcResp is Map) {
          return Map<String, dynamic>.from(rpcResp as Map);
        }
      }
    } catch (e) {
      // Jika RPC gagal (misal fungsi tidak tersedia), fallback ke client-side
      // kita tidak langsung throw di sini
      print('RPC get_statistik_warga gagal: $e');
    }

    // Fallback: ambil semua warga dan hitung statistik di client
    try {
      final List<WargaModel> list = await getAllWarga();

      final Set<int?> keluargaIds = {};
      int laki = 0, perempuan = 0, aktif = 0, nonaktif = 0;
      int kepala = 0, ibu = 0, anak = 0;
      final Map<String, int> agamaMap = {};
      final Map<String, int> pendidikanMap = {};
      final Map<String, int> pekerjaanMap = {};

      for (final w in list) {
        keluargaIds.add(w.keluargaId);

        final jk = (w.jenisKelamin ?? '').toLowerCase();
        if (jk.startsWith('l'))
          laki++;
        else if (jk.startsWith('p'))
          perempuan++;

        final st = (w.status ?? '').toLowerCase();
        if (st == 'aktif' || st == '1')
          aktif++;
        else
          nonaktif++;

        final role = (w.roleKeluarga ?? '').toLowerCase();
        if (role.contains('kepala'))
          kepala++;
        else if (role.contains('ibu') || role.contains('istri'))
          ibu++;
        else if (role.contains('anak'))
          anak++;

        if ((w.agama ?? '').isNotEmpty) {
          agamaMap[w.agama!] = (agamaMap[w.agama!] ?? 0) + 1;
        }

        if ((w.pendidikan ?? '').isNotEmpty) {
          pendidikanMap[w.pendidikan!] =
              (pendidikanMap[w.pendidikan!] ?? 0) + 1;
        }

        if ((w.pekerjaan ?? '').isNotEmpty) {
          pekerjaanMap[w.pekerjaan!] = (pekerjaanMap[w.pekerjaan!] ?? 0) + 1;
        }
      }

      final map = <String, dynamic>{
        'total_warga': list.length,
        'total_keluarga': keluargaIds.length,
        'laki': laki,
        'perempuan': perempuan,
        'aktif': aktif,
        'nonaktif': nonaktif,
        'kepala_keluarga': kepala,
        'ibu_rumah_tangga': ibu,
        'anak': anak,
        'agama': agamaMap,
        'pendidikan': pendidikanMap,
        'pekerjaan': pekerjaanMap,
      };

      return map;
    } catch (e) {
      throw Exception('Gagal membuat statistik (fallback): $e');
    }
  Future<int> countKeluarga() async {
    final List data = await client
        .from('warga')
        .select('id')
        .eq('role_keluarga', 'kepala_keluarga');

    return data.length;
  }

  @override
  Future<int> countWarga() async {
    final List data = await client.from('warga').select('id');

    return data.length;
  }
}
