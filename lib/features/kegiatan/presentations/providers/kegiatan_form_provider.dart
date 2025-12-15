import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kegiatan_form_model.dart';
import '../../data/repositories/kegiatan_repository.dart';
import '../../../../core/providers/supabase_provider.dart';

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

final kegiatanFormProvider =
    StateNotifierProvider<KegiatanFormNotifier, KegiatanFormModel>(
  (ref) => KegiatanFormNotifier(
    KegiatanRepository(ref.read(supabaseClientProvider)),
  ),
);