import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/kegiatan_statistics_model.dart';
import '../../data/repositories/kegiatan_repository.dart';

// Provider untuk Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider untuk Repository
final kegiatanRepositoryProvider = Provider<KegiatanRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return KegiatanRepository(supabase);
});

// Provider untuk Statistics
final kegiatanStatisticsProvider = FutureProvider<KegiatanStatisticsModel>((ref) async {
  final repository = ref.watch(kegiatanRepositoryProvider);
  
  try {
    final statistics = await repository.getStatistics();
    return statistics;
  } catch (e) {
    print('ERROR in kegiatanStatisticsProvider: $e');
    // Return empty statistics jika error
    return KegiatanStatisticsModel.empty();
  }
});

// Provider untuk refresh trigger (optional)
final refreshStatisticsProvider = StateProvider<int>((ref) => 0);