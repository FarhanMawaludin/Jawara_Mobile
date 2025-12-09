import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/broadcast_model.dart';
import '../../data/repositories/broadcast_repository.dart';


class BroadcastListState {
  final List<BroadcastModel> items;
  final bool isLoading;
  final String? error;

  BroadcastListState({
    this.items = const [],
    this.isLoading = false,
    this.error,
  });

  BroadcastListState copyWith({
    List<BroadcastModel>? items,
    bool? isLoading,
    String? error,
  }) {
    return BroadcastListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class BroadcastListNotifier extends StateNotifier<BroadcastListState> {
  final BroadcastRepository _repository;

  BroadcastListNotifier(this._repository) : super(BroadcastListState()) {
    loadBroadcasts();
  }

  Future<void> loadBroadcasts() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final broadcastsJson = await _repository.getBroadcastList();
      final broadcasts = broadcastsJson
          .map((json) => BroadcastModel.fromJson(json))
          .toList();

      state = state.copyWith(
        items: broadcasts,
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
    await loadBroadcasts();
  }

  void removeById(int id) {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: updatedItems);
  }

  Future<Map<String, dynamic>> deleteById(int id) async {
    try {
      final result = await _repository.deleteBroadcast(id);

      if (result['success'] != true) {
        // Jika delete gagal, reload data untuk restore item
        await loadBroadcasts();
      }

      return result;
    } catch (e) {
      // Jika error, reload data untuk restore item
      await loadBroadcasts();
      return {
        'success': false,
        'message': 'Gagal menghapus: ${e.toString()}',
      };
    }
  }
}

final broadcastListNotifierProvider =
    StateNotifierProvider<BroadcastListNotifier, BroadcastListState>((ref) {
  final repository = ref.watch(broadcastRepositoryProvider);
  return BroadcastListNotifier(repository);
});