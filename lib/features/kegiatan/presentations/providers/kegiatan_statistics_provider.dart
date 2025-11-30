import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kegiatan_statistics_model.dart';
import '../../data/repositories/kegiatan_repository.dart';
import 'kegiatan_form_provider.dart';

// Provider untuk mendapatkan statistik kegiatan
final kegiatanStatisticsProvider = FutureProvider<KegiatanStatisticsModel>((ref) async {
  final repository = ref.watch(kegiatanRepositoryProvider);
  return await repository.getStatistics();
});

// Provider untuk refresh statistik (digunakan setelah tambah/update kegiatan)
final refreshStatisticsProvider = StateProvider<int>((ref) => 0);