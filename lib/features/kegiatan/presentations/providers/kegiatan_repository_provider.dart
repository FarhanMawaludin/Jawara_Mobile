// lib/features/kegiatan/presentations/providers/kegiatan_repository_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/core/supabase_client.dart';
import '../../data/repositories/kegiatan_repository.dart';

// ✅ Provider untuk KegiatanRepository (tanpa dependency pengeluaran usecase)
final kegiatanRepositoryProvider = Provider<KegiatanRepository>((ref) {
  final supabase = SupabaseClientSingleton().client;
  
  return KegiatanRepository(supabase); // ✅ Sederhana, langsung insert
});