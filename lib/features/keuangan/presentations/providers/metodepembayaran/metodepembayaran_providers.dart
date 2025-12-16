import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/keuangan/data/repository/metodepembayaran_repository_impl.dart';
import '../../../data/datasources/metode_pembayaran_remote_datasource.dart';
import '../../../data/models/metodepembayaran_model.dart';
import '../../../domain/usecase/metodepembayaran/create_metode_pembayaran_usecase.dart';
import '../../../domain/usecase/metodepembayaran/delete_metode_pembayaran.dart';
import '../../../domain/usecase/metodepembayaran/get_metode_pembayaran_by_id_usecase.dart';
import '../../../domain/usecase/metodepembayaran/get_all_metode_pembayaran_usecase.dart';
import '../../../domain/usecase/metodepembayaran/update_metode_pembayaran_usecase.dart';

//
// DATASOURCE PROVIDER
//
final metodePembayaranDatasourceProvider =
    Provider<MetodePembayaranDatasource>((ref) {
  return MetodePembayaranDatasource();
});

//
// REPOSITORY PROVIDER
//
final metodePembayaranRepositoryProvider =
    Provider<MetodePembayaranRepositoryImpl>((ref) {
  final datasource = ref.watch(metodePembayaranDatasourceProvider);
  return MetodePembayaranRepositoryImpl(datasource);
});

//
// USECASES PROVIDER
//
final getAllMetodeUsecaseProvider =
    Provider<GetAllMetodePembayaranUsecase>((ref) {
  return GetAllMetodePembayaranUsecase(
    ref.watch(metodePembayaranRepositoryProvider),
  );
});

final getMetodeByIdUsecaseProvider =
    Provider<GetMetodePembayaranByIdUsecase>((ref) {
  return GetMetodePembayaranByIdUsecase(
    ref.watch(metodePembayaranRepositoryProvider),
  );
});

final updateMetodeUsecaseProvider =
    Provider<UpdateMetodePembayaranUsecase>((ref) {
  return UpdateMetodePembayaranUsecase(
    ref.watch(metodePembayaranRepositoryProvider),
  );
});

final createMetodeUsecaseProvider =
    Provider<CreateMetodePembayaranUsecase>((ref) {
  return CreateMetodePembayaranUsecase(
    ref.watch(metodePembayaranRepositoryProvider),
  );
});

final deleteMetodeUsecaseProvider =
    Provider<DeleteMetodePembayaran>((ref) {
  return DeleteMetodePembayaran(
    ref.watch(metodePembayaranRepositoryProvider),
  );
});

final metodePembayaranProvider =
    FutureProvider<List<MetodePembayaranModel>>((ref) async {
  final repo = ref.watch(metodePembayaranRepositoryProvider);
  return repo.getAllMetode();
});



// ======================================================================
// STATE NOTIFIER
// ======================================================================

class MetodePembayaranNotifier
    extends StateNotifier<AsyncValue<List<MetodePembayaranModel>>> {
  final GetAllMetodePembayaranUsecase getAll;
  final CreateMetodePembayaranUsecase create;
  final UpdateMetodePembayaranUsecase update;
  final DeleteMetodePembayaran delete;

  MetodePembayaranNotifier({
    required this.getAll,
    required this.create,
    required this.update,
    required this.delete,
  }) : super(const AsyncValue.loading());

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final List<MetodePembayaranModel> result = await getAll();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addMetode(MetodePembayaranModel data) async {
    try {
      await create(data);
      await loadData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateMetode(int id, MetodePembayaranModel data) async {
    try {
      await update(data);
      await loadData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteMetodeById(int id) async {
    try {
      await delete(id);
      await loadData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final metodePembayaranNotifierProvider =
    StateNotifierProvider<MetodePembayaranNotifier,
        AsyncValue<List<MetodePembayaranModel>>>((ref) {
  return MetodePembayaranNotifier(
    getAll: ref.watch(getAllMetodeUsecaseProvider),
    create: ref.watch(createMetodeUsecaseProvider),
    update: ref.watch(updateMetodeUsecaseProvider),
    delete: ref.watch(deleteMetodeUsecaseProvider),
  )..loadData();
});
