import 'package:jawaramobile/features/warga/data/models/mutasi_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class MutasiRemoteDataSource {
  Future<List<MutasiModel>> getAllMutasi();
  Future<MutasiModel?> getMutasiByKeluarga(int keluargaId);
  Future<MutasiModel?> getMutasiById(int id);
  Future<void> createMutasi(MutasiModel mutasi);
  Future<List<MutasiModel>> searchMutasi(String keyword);
  Future<void> updateRumah(int keluargaId, int? rumahId);
}

class MutasiRemoteDatasourceImpl implements MutasiRemoteDataSource {
  final SupabaseClient client;

  MutasiRemoteDatasourceImpl(this.client);
  @override
  Future<List<MutasiModel>> getAllMutasi() async {
    try {
      final List<dynamic> data = await client
          .from('mutasi_keluarga')
          .select('''
        *,
        keluarga:keluarga_id (
          id,
          nama_keluarga
        )
      ''')
          .order('id', ascending: true);

      return data.map((json) => MutasiModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data Mutasi: $e");
    }
  }

  @override
  Future<MutasiModel?> getMutasiByKeluarga(int keluargaId) async {
    try {
      final data = await client
          .from('mutasi_keluarga')
          .select('''
            *,
            keluarga:keluarga_id (
              id,
              nama_keluarga
            )
          ''')
          .eq('keluarga_id', keluargaId)
          .maybeSingle();

      if (data == null) return null;

      return MutasiModel.fromMap(data);
    } catch (e) {
      throw Exception(
        "Gagal mengambil detail Mutasi berdasarkan keluarga_id: $e",
      );
    }
  }

  @override
  Future<MutasiModel?> getMutasiById(int id) async {
    try {
      final data = await client
          .from('mutasi_keluarga')
          .select('''
            *,
            keluarga:keluarga_id (
              id,
              nama_keluarga
            )
          ''')
          .eq('id', id)
          .maybeSingle();

      if (data == null) return null;

      return MutasiModel.fromMap(data);
    } catch (e) {
      throw Exception("Gagal mengambil detail Mutasi: $e");
    }
  }

  @override
  Future<void> createMutasi(MutasiModel mutasi) async {
    try {
      // --- VALIDASI JENIS MUTASI ---
      if (mutasi.jenisMutasi == 'pindah_rumah') {
        if (mutasi.rumahId == null) {
          throw Exception(
            "rumah_id (rumah lama) wajib diisi untuk pindah_rumah",
          );
        }
        if (mutasi.rumahSekarangId == null) {
          throw Exception(
            "rumah_sekarang_id (rumah baru) wajib diisi untuk pindah_rumah",
          );
        }
      }

      if (mutasi.jenisMutasi == 'keluar_perumahan') {
        if (mutasi.rumahId == null) {
          throw Exception(
            "rumah_id (rumah lama) wajib diisi untuk keluar_perumahan",
          );
        }

        // rumah baru harus null
        mutasi = mutasi.copyWith(rumahSekarangId: null);
      }

      // --- INSERT DATA ---
      await client.from('mutasi_keluarga').insert({
        'keluarga_id': mutasi.keluargaId,
        'rumah_id': mutasi.rumahId,
        'rumah_sekarang_id': mutasi.rumahSekarangId,
        'jenis_mutasi': mutasi.jenisMutasi,
        'alasan_mutasi': mutasi.alasanMutasi,
        'tanggal_mutasi': mutasi.tanggalMutasi?.toIso8601String(),
      });
    } catch (e) {
      throw Exception("Gagal membuat data Mutasi: $e");
    }
  }

  @override
  Future<List<MutasiModel>> searchMutasi(String keyword) async {
    try {
      final result = await client
          .from('mutasi_keluarga')
          .select('*, keluarga:keluarga_id!inner(id, nama_keluarga)')
          .ilike('keluarga.nama_keluarga', '%$keyword%');

      return result.map((json) => MutasiModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mencari Mutasi: $e");
    }
  }

  @override
  Future<void> updateRumah(int keluargaId, int? rumahBaruId) async {
    try {
      // 1️⃣ Cari rumah asal dari keluarga tersebut
      final rumahAsal = await client
          .from('rumah')
          .select('id')
          .eq('keluarga_id', keluargaId)
          .maybeSingle();

      // 2️⃣ Kosongkan rumah asal (agar tidak ditempati lagi)
      if (rumahAsal != null && rumahAsal['id'] != null) {
        await client
            .from('rumah')
            .update({'keluarga_id': null})
            .eq('id', rumahAsal['id']);
      }

      // 3️⃣ Jika pindah rumah → isi rumah baru dengan keluargaId
      if (rumahBaruId != null) {
        await client
            .from('rumah')
            .update({'keluarga_id': keluargaId})
            .eq('id', rumahBaruId);
      }
    } catch (e) {
      throw Exception("Gagal mengupdate rumah keluarga: $e");
    }
  }
}
