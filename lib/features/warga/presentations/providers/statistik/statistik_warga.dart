import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/statistik.dart';
import '../../../domain/usecases/warga/get_statistik_warga.dart';
import '../warga/warga_providers.dart';

/// State object for statistik
class StatistikWargaState {
  final bool isLoading;
  final StatistikWarga? data;
  final String? error;

  StatistikWargaState({this.isLoading = false, this.data, this.error});

  StatistikWargaState copyWith({
    bool? isLoading,
    StatistikWarga? data,
    String? error,
  }) {
    return StatistikWargaState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }

  factory StatistikWargaState.initial() => StatistikWargaState();
}

class StatistikWargaController extends StateNotifier<StatistikWargaState> {
  final GetStatistikWarga _usecase;

  StatistikWargaController(this._usecase)
    : super(StatistikWargaState.initial()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final result = await _usecase.call();
      state = state.copyWith(isLoading: false, data: result);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> retry() async => load();
}

final statistikWargaControllerProvider =
    StateNotifierProvider<StatistikWargaController, StatistikWargaState>((ref) {
      final usecase = ref.read(getStatistikWargaUseCaseProvider);
      return StatistikWargaController(usecase);
    });
