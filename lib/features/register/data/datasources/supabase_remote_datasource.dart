// lib/data/datasources/supabase_remote_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/supabase_client.dart';
import '../models/user_app_model.dart';
import '../models/keluarga_model.dart';
import '../models/warga_model.dart';
import '../models/rumah_model.dart';

class SupabaseRemoteDatasource {
  final SupabaseClient client = SupabaseClientSingleton().client;

  Future<UserAppModel> registerAccount(String email, String password) async {
    final response = await client.auth.signUp(email: email, password: password);
    final user = response.user;
    if (user == null) {
      throw Exception('Failed to register account');
    }

    final userAppData = await client.from('user_app').insert({
      'id': user.id,
      'role': 'kepala_keluarga',
    }).select();

    return UserAppModel.fromJson(userAppData.first);
  }

  Future<(KeluargaModel, WargaModel)> createKeluargaAndWarga(
    String userId,
    String namaKeluarga,
    String nama,
    String? nik,
    String? jenisKelamin,
    DateTime? tanggalLahir,
    String roleKeluarga,
  ) async {
    final keluargaData = await client.from('keluarga').insert({
      'user_id': userId,
      'nama_keluarga': namaKeluarga,
    }).select();

    final keluarga = KeluargaModel.fromJson(
      keluargaData.first,
    );

    final wargaData = await client.from('warga').insert({
      'keluarga_id': keluarga.id,
      'nama': nama,
      'nik': nik,
      'jenis_kelamin': jenisKelamin,
      'tanggal_lahir': tanggalLahir?.toIso8601String(),
      'role_keluarga': roleKeluarga,
    }).select();

    final warga = WargaModel.fromJson(wargaData.first);

    return (keluarga, warga);
  }

  Future<RumahModel> createRumah(
    int keluargaId,
    String? blok,
    String? nomorRumah,
    String? alamatLengkap,
  ) async {
    // 1. Insert rumah
    final rumahData = await client.from('rumah').insert({
      'keluarga_id': keluargaId,
      'blok': blok,
      'nomor_rumah': nomorRumah,
      'alamat_lengkap': alamatLengkap,
    }).select();

    final rumahJson = rumahData.first;
    final rumah = RumahModel.fromJson(rumahJson);

    // 2. UPDATE warga → set alamat_rumah_id untuk kepala keluarga
    await client
        .from('warga')
        .update({'alamat_rumah_id': rumah.id})
        .eq('keluarga_id', keluargaId)
        .eq('role_keluarga', 'kepala_keluarga');

    return rumah;
  }
}
