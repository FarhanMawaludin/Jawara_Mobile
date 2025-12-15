import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/tagihiuran_remote_datasource.dart';
import '../../../data/repository/tagihiuran_repository_impl.dart';

import '../../../domain/entities/tagihiuran.dart';
import '../../../domain/usecase/tagihiuran/create_tagihan_usecase.dart';
import '../../../domain/usecase/tagihiuran/delete_tagihan_usecase.dart';
import '../../../domain/usecase/tagihiuran/get_all_tagihan_usecase.dart';
import '../../../domain/usecase/tagihiuran/get_tagihan_by_id_usecase.dart';
import '../../../domain/usecase/tagihiuran/update_tagihan_usecase.dart';


// ============================================================================
// DATASOURCE PROVIDER
// ============================================================================
final tagihIuranDatasourceProvider = Provider<TagihIuranRemoteDatasource>((ref) {
  return TagihIuranRemoteDatasource();
});

// ============================================================================
// REPOSITORY PROVIDER
// ============================================================================
final tagihIuranRepositoryProvider = Provider<TagihIuranRepositoryImpl>((ref) {
  final ds = ref.watch(tagihIuranDatasourceProvider);
  return TagihIuranRepositoryImpl(ds);
});

// ============================================================================
// USECASE PROVIDERS
// ============================================================================
final getAllTagihIuranUsecaseProvider =
    Provider<GetAllTagihanUsecase>((ref) {
  return GetAllTagihanUsecase(ref.watch(tagihIuranRepositoryProvider));
});

final getTagihIuranByIdUsecaseProvider =
    Provider<GetTagihanByIdUsecase>((ref) {
  return GetTagihanByIdUsecase(ref.watch(tagihIuranRepositoryProvider));
});

final createTagihIuranUsecaseProvider =
    Provider<CreateTagihanUsecase>((ref) {
  return CreateTagihanUsecase(ref.watch(tagihIuranRepositoryProvider));
});

final updateTagihIuranUsecaseProvider =
    Provider<UpdateTagihanUsecase>((ref) {
  return UpdateTagihanUsecase(ref.watch(tagihIuranRepositoryProvider));
});

final deleteTagihIuranUsecaseProvider =
    Provider<DeleteTagihanUsecase>((ref) {
  return DeleteTagihanUsecase(ref.watch(tagihIuranRepositoryProvider));
});


// ============================================================================
// STATE NOTIFIER (CRUD + STATE)
// ============================================================================
class TagihIuranState {
  final List<TagihIuran> data;
  final bool isLoading;
  final String? error;

  TagihIuranState({
    required this.data,
    this.isLoading = false,
    this.error,
  });

  TagihIuranState copyWith({
    List<TagihIuran>? data,
    bool? isLoading,
    String? error,
  }) {
    return TagihIuranState(
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TagihIuranNotifier extends StateNotifier<TagihIuranState> {
  final GetAllTagihanUsecase getAllUC;
  final GetTagihanByIdUsecase getByIdUC;
  final CreateTagihanUsecase createUC;
  final UpdateTagihanUsecase updateUC;
  final DeleteTagihanUsecase deleteUC;

  TagihIuranNotifier({
    required this.getAllUC,
    required this.getByIdUC,
    required this.createUC,
    required this.updateUC,
    required this.deleteUC,
  }) : super(TagihIuranState(data: []));

  // GET ALL
  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    try {
      final result = await getAllUC();
      state = state.copyWith(data: result, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
  Future<void> create({
    required int kategoriId,
    required String nama,
    required int jumlah,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await createUC(
        kategoriId: kategoriId,
        nama: nama,
        jumlah: jumlah,
      );
      await loadAll();
      state = state.copyWith(isLoading: false);
    } catch (e, stackTrace) {
        print('❌ Create Tagihan Error: $e');
        print('📍 StackTrace: $stackTrace');
    
        state = state.copyWith(
          error: e.toString(),
          isLoading: false,
        );
      rethrow;
    }
  }

  // UPDATE
  Future<void> update(TagihIuran item) async {
    state = state.copyWith(isLoading: true);
    try {
      await updateUC(item.id, item);
      await loadAll();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }

  // DELETE
  Future<void> delete(int id) async {
    state = state.copyWith(isLoading: true);
    try {
      await deleteUC(id);
      await loadAll();
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
      rethrow;
    }
  }
}


// ============================================================================
// STATE NOTIFIER PROVIDER
// ============================================================================
final tagihIuranNotifierProvider =
    StateNotifierProvider<TagihIuranNotifier, TagihIuranState>((ref) {
  return TagihIuranNotifier(
    getAllUC: ref.watch(getAllTagihIuranUsecaseProvider),
    getByIdUC: ref.watch(getTagihIuranByIdUsecaseProvider),
    createUC: ref.watch(createTagihIuranUsecaseProvider),
    updateUC: ref.watch(updateTagihIuranUsecaseProvider),
    deleteUC: ref.watch(deleteTagihIuranUsecaseProvider),
  );
});


// ============================================================================
// DETAIL PROVIDER (future provider by ID)
// ============================================================================
final tagihIuranDetailProvider =
    FutureProvider.family<TagihIuran?, int>((ref, id) async {
  final usecase = ref.watch(getTagihIuranByIdUsecaseProvider);
  return await usecase(id);
});