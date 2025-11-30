import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kegiatan_model.dart';
import '../../data/repositories/kegiatan_repository.dart';
import 'kegiatan_statistics_provider.dart';

class KegiatanListState {
  final List<KegiatanModel> items;
  final bool isLoading;
  final String? error;

  KegiatanListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  KegiatanListState copyWith({
    List<KegiatanModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return KegiatanListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class KegiatanListNotifier extends StateNotifier<KegiatanListState> {
  final KegiatanRepository _repository;

  KegiatanListNotifier(this._repository) : super(KegiatanListState()) {
    loadKegiatan();
  }

  Future<void> loadKegiatan() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final kegiatanJson = await _repository.getKegiatanList();
      final kegiatan = kegiatanJson
          .map((json) => KegiatanModel.fromJson(json))
          .toList();

      state = state.copyWith(
        items: kegiatan,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await loadKegiatan();
  }

  void removeById(int id) {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: updatedItems);
  }

  Future<Map<String, dynamic>> deleteById(int id) async {
    try {
      final result = await _repository.deleteKegiatan(id);

      if (result['success'] != true) {
        await loadKegiatan();
      }

      return result;
    } catch (e) {
      await loadKegiatan();
      return {
        'success': false,
        'message': 'Gagal menghapus: ${e.toString()}',
      };
    }
  }
}

final kegiatanListNotifierProvider =
    StateNotifierProvider<KegiatanListNotifier, KegiatanListState>((ref) {
  final repository = ref.watch(kegiatanRepositoryProvider);
  return KegiatanListNotifier(repository);
});