// lib/features/keuangan/presentations/providers/pengeluaran/pengeluaran_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/repository/pengeluaran_repository_impl.dart';
import '../../../domain/entities/pengeluaran.dart';
import '../../../domain/usecase/pengeluaran/create_pengeluaran_usecase.dart';
import '../../../domain/usecase/pengeluaran/delete_pengeluaran_usecase.dart';
import '../../../domain/usecase/pengeluaran/get_all_pengeluaran_usecase.dart';
import '../../../domain/usecase/pengeluaran/get_pengeluaran_by_id_usecase.dart';
import '../../../domain/usecase/pengeluaran/update_pengeluaran_usecase.dart';
import '../../../data/datasources/pengeluaran_remote_datasource.dart';


// =========================================================
// REPOSITORY PROVIDER
// =========================================================
final pengeluaranRepositoryProvider =
    Provider<PengeluaranRepositoryImpl>((ref) {
  return PengeluaranRepositoryImpl(PengeluaranRemoteDatasource());
});


// =========================================================
// USECASE PROVIDERS
// =========================================================
final getAllPengeluaranUsecaseProvider =
    Provider<GetAllPengeluaranUsecase>((ref) {
  return GetAllPengeluaranUsecase(ref.read(pengeluaranRepositoryProvider));
});

final getPengeluaranByIdUsecaseProvider =
    Provider<GetPengeluaranByIdUsecase>((ref) {
  return GetPengeluaranByIdUsecase(ref.read(pengeluaranRepositoryProvider));
});

final createPengeluaranUsecaseProvider =
    Provider<CreatePengeluaranUsecase>((ref) {
  return CreatePengeluaranUsecase(ref.read(pengeluaranRepositoryProvider));
});

final updatePengeluaranUsecaseProvider =
    Provider<UpdatePengeluaranUsecase>((ref) {
  return UpdatePengeluaranUsecase(ref.read(pengeluaranRepositoryProvider));
});

final deletePengeluaranUsecaseProvider =
    Provider<DeletePengeluaranUsecase>((ref) {
  return DeletePengeluaranUsecase(ref.read(pengeluaranRepositoryProvider));
});


// =========================================================
// STATE FINAL UNTUK UI
// =========================================================
class PengeluaranState {
  final List<Pengeluaran> data;
  final bool isLoading;
  final String? error;

  PengeluaranState({
    required this.data,
    this.isLoading = false,
    this.error,
  });

  PengeluaranState copyWith({
    List<Pengeluaran>? data,
    bool? isLoading,
    String? error,
  }) {
    return PengeluaranState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}


// =========================================================
// NOTIFIER: CRUD LOGIC
// =========================================================
class PengeluaranNotifier extends StateNotifier<PengeluaranState> {
  final GetAllPengeluaranUsecase getAllUC;
  final CreatePengeluaranUsecase createUC;
  final UpdatePengeluaranUsecase updateUC;
  final DeletePengeluaranUsecase deleteUC;

  PengeluaranNotifier({
    required this.getAllUC,
    required this.createUC,
    required this.updateUC,
    required this.deleteUC,
  }) : super(PengeluaranState(data: []));

  Future<void> load() async {
    state = state.copyWith(isLoading: true);

    try {
      final result = await getAllUC.call();
      state = state.copyWith(data: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> create(Pengeluaran item) async {
    await createUC.call(item);
    await load();
  }

  Future<void> update(Pengeluaran item) async {
    await updateUC.call(item);
    await load();
  }

  Future<void> delete(int id) async {
    await deleteUC.call(id);
    await load();
  }
}


// =========================================================
// PROVIDER UNTUK NOTIFIER
// =========================================================
final pengeluaranNotifierProvider =
    StateNotifierProvider<PengeluaranNotifier, PengeluaranState>((ref) {
  return PengeluaranNotifier(
    getAllUC: ref.read(getAllPengeluaranUsecaseProvider),
    createUC: ref.read(createPengeluaranUsecaseProvider),
    updateUC: ref.read(updatePengeluaranUsecaseProvider),
    deleteUC: ref.read(deletePengeluaranUsecaseProvider),
  );
});

// Provider untuk hitung total pengeluaran
final totalPengeluaranProvider = Provider<double>((ref) {
  final state = ref.watch(pengeluaranNotifierProvider);
  return state.data.fold<double>(0.0, (sum, pengeluaran) => sum + pengeluaran.jumlah);
});
