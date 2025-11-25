import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/rumah_model.dart';

abstract class RumahRemoteDataSource {
  Future<List<RumahModel>> getAllRumah();
  Future<RumahModel?> getRumahById(int id);
  Future<List<RumahModel>> getRumahByKeluarga(int keluargaId);
  Future<void> createRumah(RumahModel rumah);
  Future<void> updateRumah(RumahModel rumah);
  Future<void> deleteRumah(int id);
  Future<List<RumahModel>> searchRumah(String keyword);
}

class RumahRemoteDataSourceImpl implements RumahRemoteDataSource {
  final SupabaseClient client;

  RumahRemoteDataSourceImpl(this.client);

  @override
  Future<List<RumahModel>> getAllRumah() async {
    try {
      final List<dynamic> data = await client
          .from('rumah')
          .select('''
        *,
        keluarga:keluarga_id (
          id,
          nama_keluarga
        )
      ''')
          .order('id', ascending: true);

      return data.map((json) => RumahModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil data Rumah: $e");
    }
  }

  @override
  Future<RumahModel?> getRumahById(int id) async {
    try {
      final data = await client
          .from('rumah')
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

      return RumahModel.fromMap(data);
    } catch (e) {
      throw Exception("Gagal mengambil detail Rumah: $e");
    }
  }

  @override
  Future<List<RumahModel>> getRumahByKeluarga(int keluargaId) async {
    try {
      final List<dynamic> data = await client
          .from('rumah')
          .select('''
            *,
            keluarga:keluarga_id (
              id,
              nama_keluarga
            )
          ''')
          .eq('keluarga_id', keluargaId);

      return data.map((json) => RumahModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal mengambil Rumah berdasarkan keluarga_id: $e");
    }
  }

  @override
  Future<Rumah> createRumah(Rumah rumah) async {
    final Map<String, dynamic> data = {
      if (rumah.keluargaId != null) 'keluarga_id': rumah.keluargaId,
      'blok': rumah.blok,
      'nomor_rumah': rumah.nomorRumah,
      'alamat_lengkap': rumah.alamatLengkap,
      'created_at': rumah.createdAt.toIso8601String(),
    };

    final result = await client.from('rumah').insert(data).select().single();

    return RumahModel.fromMap(result);
  }

  @override
  Future<void> updateRumah(RumahModel rumah) async {
    final response = await client
        .from('rumah')
        .update(rumah.toMap())
        .eq('id', rumah.id)
        .select(); // <-- WAJIB (tanpa ini return-nya null)

    // Kalau select() gagal → akan throw otomatis
    if (response.isEmpty) {
      throw Exception("Gagal memperbarui data Rumah");
    }
  }

  @override
  @override
  Future<void> deleteRumah(int id) async {
    try {
      await client.from('rumah').delete().eq('id', id);
    } catch (e) {
      throw Exception("Gagal menghapus data Rumah: $e");
    }
  }

  @override
  Future<List<RumahModel>> searchRumah(String keyword) async {
    try {
      final List<dynamic> data = await client
          .from('rumah')
          .select('''
          *,
          keluarga:keluarga_id (
            id,
            nama_keluarga
          )
        ''')
          .or(
            'blok.ilike.%$keyword%,'
            'nomor_rumah.ilike.%$keyword%,'
            'alamat_lengkap.ilike.%$keyword%',
          );

      return data.map((json) => RumahModel.fromMap(json)).toList();
    } catch (e) {
      throw Exception("Gagal melakukan pencarian Rumah: $e");
    }
  }
}
