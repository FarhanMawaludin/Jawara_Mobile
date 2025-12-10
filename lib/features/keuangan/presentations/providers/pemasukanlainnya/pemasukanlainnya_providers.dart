import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repository/pemasukanlainnya_repository_impl.dart';
import '../../../domain/entities/pemasukanlainnya.dart';
import '../../../domain/usecase/pemasukanlainnya/create_pemasukanlainnya_usecase.dart';
import '../../../domain/usecase/pemasukanlainnya/delete_pemasukanlainnya.dart';
import '../../../domain/usecase/pemasukanlainnya/get_all_pemasukanlainnya_usecase.dart';
import '../../../domain/usecase/pemasukanlainnya/get_pemasukanlainnya_by_id_usecase.dart';
import '../../../domain/usecase/pemasukanlainnya/update_pemasukanlainnya.dart';
import '../../../domain/repositories/pemasukanlainnya_repository.dart';
import '../../../data/datasources/pemasukanlainnya_remote_datasource.dart';

final pemasukanLainnyaDatasourceProvider =
    Provider<PemasukanLainnyaDatasource>(
  (ref) => PemasukanLainnyaDatasource(),
);

final pemasukanLainnyaRepositoryProvider =
    Provider<PemasukanLainnyaRepository>(
  (ref) {
    final datasource = ref.watch(pemasukanLainnyaDatasourceProvider);
    return PemasukanLainnyaRepositoryImpl(datasource);
  },
);


final getAllPemasukanUsecaseProvider =
    Provider<GetAllPemasukanLainnyaUsecase>((ref) {
  final repo = ref.watch(pemasukanLainnyaRepositoryProvider);
  return GetAllPemasukanLainnyaUsecase(repo);
});

final getPemasukanByIdUsecaseProvider =
    Provider<GetPemasukanByIdUsecase>((ref) {
  final repo = ref.watch(pemasukanLainnyaRepositoryProvider);
  return GetPemasukanByIdUsecase(repo);
});

final createPemasukanUsecaseProvider =
    Provider<CreatePemasukanUsecase>((ref) {
  final repo = ref.watch(pemasukanLainnyaRepositoryProvider);
  return CreatePemasukanUsecase(repo);
});

final updatePemasukanUsecaseProvider =
    Provider<UpdatePemasukanUsecase>((ref) {
  final repo = ref.watch(pemasukanLainnyaRepositoryProvider);
  return UpdatePemasukanUsecase(repo);
});

final deletePemasukanUsecaseProvider =
    Provider<DeletePemasukanLainnyaUsecase>((ref) {
  final repo = ref.watch(pemasukanLainnyaRepositoryProvider);
  return DeletePemasukanLainnyaUsecase(repo);
});

final pemasukanDetailNotifierProvider = StateNotifierProvider
    .family<PemasukanDetailNotifier, AsyncValue<PemasukanLainnya?>, int>(
  (ref, id) {
    return PemasukanDetailNotifier(
      getById: ref.watch(getPemasukanByIdUsecaseProvider),
      id: id,
    )..load(); // otomatis ambil data
  },
);


// ------------------------------------------------------------
// NOTIFIER UNTUK LIST DATA (READ, CREATE, UPDATE, DELETE)
// ------------------------------------------------------------

final pemasukanNotifierProvider = StateNotifierProvider<PemasukanNotifier,
    AsyncValue<List<PemasukanLainnya>>>((ref) {
  return PemasukanNotifier(
    getAll: ref.watch(getAllPemasukanUsecaseProvider),
    create: ref.watch(createPemasukanUsecaseProvider),
    update: ref.watch(updatePemasukanUsecaseProvider),
    delete: ref.watch(deletePemasukanUsecaseProvider),
  );
});
class PemasukanNotifier extends StateNotifier<AsyncValue<List<PemasukanLainnya>>> {
  final GetAllPemasukanLainnyaUsecase getAll;
  final CreatePemasukanUsecase create;
  final UpdatePemasukanUsecase update;
  final DeletePemasukanLainnyaUsecase delete;

  PemasukanNotifier({
    required this.getAll,
    required this.create,
    required this.update,
    required this.delete,
  }) : super(const AsyncValue.loading()) {
    loadData();
  }

  Future<void> loadData() async {
    state = const AsyncValue.loading();
    try {
      final result = await getAll();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createData(PemasukanLainnya data) async {
    state = const AsyncValue.loading();
    await create(data);
    await loadData();
  }

  Future<void> updateData(PemasukanLainnya data) async {
    state = const AsyncValue.loading();
    await update(data);
    await loadData();
  }

  Future<void> deleteData(int id) async {
    await delete(id);
    await loadData();
  }
}

class PemasukanDetailNotifier
  extends StateNotifier<AsyncValue<PemasukanLainnya?>> {
  final GetPemasukanByIdUsecase getById;
  final int id;

  PemasukanDetailNotifier({
    required this.getById,
    required this.id,
  }) : super(const AsyncValue.loading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    try {
      final res = await getById(id);
      state = AsyncValue.data(res);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

// Provider untuk hitung total pemasukan
final totalPemasukanProvider = Provider<AsyncValue<double>>((ref) {
  final pemasukanAsync = ref.watch(pemasukanNotifierProvider);
  return pemasukanAsync.whenData((list) {
    return list.fold<double>(0.0, (sum, pemasukan) => sum + pemasukan.jumlah);
  });
});
