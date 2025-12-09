import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../lib/features/kegiatan/data/repositories/kegiatan_repository.dart';
import '../../lib/features/broadcast/data/repositories/broadcast_repository.dart';
import 'test_helpers.dart';

/// Mock Kegiatan Repository Provider
final mockKegiatanRepositoryProvider = Provider<KegiatanRepository>((ref) {
  final supabaseClient = TestHelpers.getSupabaseClient();
  return KegiatanRepository(supabaseClient);
});

/// Mock Broadcast Repository Provider
final mockBroadcastRepositoryProvider = Provider<BroadcastRepository>((ref) {
  final supabaseClient = TestHelpers.getSupabaseClient();
  return BroadcastRepository(supabaseClient);
});

/// Create ProviderContainer for testing
ProviderContainer createContainer({
  List<Override>? overrides,
}) {
  return ProviderContainer(
    overrides: overrides ?? [],
  );
}