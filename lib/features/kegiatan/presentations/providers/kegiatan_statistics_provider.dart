import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kegiatan_statistics_model.dart';
import 'kegiatan_repository_provider.dart'; // ✅ Import dari satu tempat

// ✅ HANYA gunakan provider, TIDAK define lagi
final kegiatanStatisticsProvider = FutureProvider<KegiatanStatisticsModel>((ref) async {
  final repository = ref.watch(kegiatanRepositoryProvider);
  return await repository.getStatistics();
});