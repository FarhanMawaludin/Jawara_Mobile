import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kegiatan_form_model.dart';
import '../../data/repositories/kegiatan_repository.dart';
import '../../../../core/providers/supabase_provider.dart'; // Import supabase provider

class KegiatanFormNotifier extends StateNotifier<KegiatanFormModel> {
  final KegiatanRepository _repository;

  KegiatanFormNotifier(this._repository) : super(KegiatanFormModel());

  void updateNamaKegiatan(String value) {
    state = state.copyWith(namaKegiatan: value);
  }

  void updateTanggalKegiatan(DateTime value) {
    state = state.copyWith(tanggalKegiatan: value);
  }

  void updateLokasi(String value) {
    state = state.copyWith(lokasi: value);
  }

  void updatePenanggungJawab(String value) {
    state = state.copyWith(penanggungJawab: value);
  }

  void updateDeskripsi(String value) {
    state = state.copyWith(deskripsi: value);
  }

  void updateKategori(String value) {
    state = state.copyWith(kategori: value);
  }

  void reset() {
    state = KegiatanFormModel();
  }

  // Submit ke Supabase
  Future<Map<String, dynamic>> submitForm() async {
    try {
      final result = await _repository.createKegiatan(state);

      if (result['success']) {
        // Reset state HANYA setelah berhasil submit
        reset();
      }

      return result;
    } catch (e) {
      return {
        'success': false,
        'message': 'Terjadi kesalahan: $e',
      };
    }
  }
}

// Provider untuk KegiatanRepository - UPDATED
final kegiatanRepositoryProvider = Provider<KegiatanRepository>((ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return KegiatanRepository(supabaseClient);
});

// Provider untuk KegiatanFormNotifier
final kegiatanFormProvider =
    StateNotifierProvider<KegiatanFormNotifier, KegiatanFormModel>(
  (ref) {
    final repository = ref.watch(kegiatanRepositoryProvider);
    return KegiatanFormNotifier(repository);
  },
);