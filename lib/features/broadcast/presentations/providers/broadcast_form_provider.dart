import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/broadcast_form_model.dart';
import '../../data/repositories/broadcast_repository.dart';

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

final broadcastRepositoryProvider = Provider<BroadcastRepository>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return BroadcastRepository(supabase);
});

class BroadcastFormNotifier extends StateNotifier<BroadcastFormModel> {
  final BroadcastRepository _repository;

  BroadcastFormNotifier(this._repository) : super(BroadcastFormModel());

  void updateJudul(String value) {
    state = state.copyWith(judul: value);
  }

  void updateIsi(String value) {
    state = state.copyWith(isi: value);
  }

  void updateFotoPath(String? path) {
    state = state.copyWith(fotoPath: path);
  }

  void updateDokumenPath(String? path) {
    state = state.copyWith(dokumenPath: path);
  }

  void reset() {
    state = BroadcastFormModel();
  }

  Future<Map<String, dynamic>> submitForm() async {
    try {
      if (!state.isValid) {
        return {
          'success': false,
          'message': 'Harap lengkapi semua field yang wajib diisi',
        };
      }

      final result = await _repository.createBroadcast(state);

      if (result['success'] == true) {
        reset();
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: ${e.toString()}',
      };
    }
  }
}

final broadcastFormProvider =
    StateNotifierProvider<BroadcastFormNotifier, BroadcastFormModel>((ref) {
  final repository = ref.watch(broadcastRepositoryProvider);
  return BroadcastFormNotifier(repository);
});