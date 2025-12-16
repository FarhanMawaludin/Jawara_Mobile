import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/kegiatan_model.dart';
import '../../data/repositories/kegiatan_repository.dart';
import 'kegiatan_statistics_provider.dart';
import 'kegiatan_repository_provider.dart';

class KegiatanListState {
  final List<KegiatanModel> items;
  final bool isLoading;
  final bool isLoadingMore;
  final String? error;
  final int page;
  final bool hasMore;

  const KegiatanListState({
    this.items = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.error,
    this.page = 0,
    this.hasMore = true,
  });

  KegiatanListState copyWith({
    List<KegiatanModel>? items,
    bool? isLoading,
    bool? isLoadingMore,
    String? error,
    int? page,
    bool? hasMore,
  }) {
    return KegiatanListState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      error: error,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class KegiatanListNotifier extends StateNotifier<KegiatanListState> {
  final KegiatanRepository _repository;
  final Ref _ref;
  static const int _pageSize = 10;

  KegiatanListNotifier(this._repository, this._ref)
      : super(const KegiatanListState()) {
    loadInitial();
  }

  Future<void> loadInitial() async {
    state = state.copyWith(
      isLoading: true,
      error: null,
      page: 0,
      items: [],
    );

    try {
      final kegiatanJson = await _repository.getKegiatanList(
        limit: _pageSize,
        offset: 0,
      );

      final kegiatan = kegiatanJson
          .map((json) => KegiatanModel.fromJson(json))
          .toList();

      state = state.copyWith(
        items: kegiatan,
        isLoading: false,
        page: 1,
        hasMore: kegiatan.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    state = state.copyWith(isLoadingMore: true);

    try {
      final offset = state.page * _pageSize;

      final kegiatanJson = await _repository.getKegiatanList(
        limit: _pageSize,
        offset: offset,
      );

      final newItems = kegiatanJson
          .map((json) => KegiatanModel.fromJson(json))
          .toList();

      state = state.copyWith(
        items: [...state.items, ...newItems],
        isLoadingMore: false,
        page: state.page + 1,
        hasMore: newItems.length >= _pageSize,
      );
    } catch (e) {
      state = state.copyWith(isLoadingMore: false);
    }
  }

  Future<void> refresh() async {
    await loadInitial();
    _ref.invalidate(kegiatanStatisticsProvider);
  }

  void removeById(int id) {
    final updatedItems = state.items.where((item) => item.id != id).toList();
    state = state.copyWith(items: updatedItems);
  }

  Future<Map<String, dynamic>> deleteById(int id) async {
    try {
      final result = await _repository.deleteKegiatan(id);

      if (result['success'] == true) {
        removeById(id);
        _ref.invalidate(kegiatanStatisticsProvider);
      }

      return result;
    } catch (e) {
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
  return KegiatanListNotifier(repository, ref);
});