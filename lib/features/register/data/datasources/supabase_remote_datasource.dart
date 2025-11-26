// lib/data/datasources/supabase_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase_client.dart';

class SupabaseRemoteDatasource {
  final SupabaseClient client = SupabaseClientSingleton().client;

  // ========================================================
  // STEP 1 — Register Account → return userId
  // ========================================================
  Future<String> registerAccount(String email, String password) async {
    final response = await client.auth.signUp(email: email, password: password);

    final user = response.user;
    if (user == null) {
      throw Exception('Failed to register account');
    }

    // Tambahkan data ke tabel user_app
    await client.from('user_app').insert({
      'id': user.id,
      'role': 'kepala_keluarga',
    });

    return user.id; // === return userId ===
  }

  // ========================================================
  // STEP 2 — Create Keluarga + Warga → return keluargaId
  // ========================================================
  Future<int> createKeluargaAndWarga({
    required String userId,
    required String nama,
    required String? nik,
    required String? jenisKelamin,
    required DateTime? tanggalLahir,
    required String roleKeluarga,
  }) async {
    // 1. INSERT keluarga
    final keluargaData = await client.from('keluarga').insert({
      'user_id': userId,
      'nama_keluarga': nama, // otomatis nama kepala keluarga
    }).select();

    final keluargaId = keluargaData.first['id'] as int;

    // 2. INSERT warga (kepala keluarga)
    await client.from('warga').insert({
      'keluarga_id': keluargaId,
      'nama': nama,

      // 🔥 Fix bagian nik → ubah "" menjadi NULL
      'nik': (nik == null || nik.trim().isEmpty) ? null : nik,

      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'role_keluarga': roleKeluarga,
    });

    return keluargaId;
  }

  // ========================================================
  // STEP 3 — Create Rumah → return rumahId
  // ========================================================
  Future<int> createRumah({
    required int keluargaId,
    required String? blok,
    required String? nomorRumah,
    required String? alamatLengkap,
  }) async {
    // 1. INSERT rumah
    final rumahData = await client.from('rumah').insert({
      'keluarga_id': keluargaId,
      'blok': blok,
      'nomor_rumah': nomorRumah,
      'alamat_lengkap': alamatLengkap,
    }).select();

    final rumahId = rumahData.first['id'] as int;

    // 2. Update warga untuk kepala keluarga → set alamat_rumah_id
    await client
        .from('warga')
        .update({'alamat_rumah_id': rumahId})
        .eq('keluarga_id', keluargaId)
        .eq('role_keluarga', 'kepala_keluarga');

    return rumahId;
  }
}
