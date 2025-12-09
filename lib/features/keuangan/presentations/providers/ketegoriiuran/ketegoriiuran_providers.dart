import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/kategoriiuran_remote_datasource.dart';
import '../../../data/repository/kategoriiuran_repository_impl.dart';
import '../../../data/models/kategoriiuran_model.dart';

import '../../../domain/usecase/ketegoriiuran/create_kategori_usecase.dart';
import '../../../domain/usecase/ketegoriiuran/delete_kategori_usecase.dart';
import '../../../domain/usecase/ketegoriiuran/get_all_kategori_usecase.dart';
import '../../../domain/usecase/ketegoriiuran/get_kategori_by_id_usecase.dart';
import '../../../domain/usecase/ketegoriiuran/update_kategori_usecase.dart';

//
// DATASOURCE PROVIDER
//
final kategoriIuranDatasourceProvider = Provider<KategoriIuranDatasource>((ref) {
  return KategoriIuranDatasource();
});

//
// REPOSITORY PROVIDER
//
final kategoriIuranRepositoryProvider = Provider<KategoriIuranRepositoryImpl>((ref) {
  final datasource = ref.watch(kategoriIuranDatasourceProvider);
  return KategoriIuranRepositoryImpl(datasource);
});

//
// USECASES PROVIDER
//
final createKategoriUsecaseProvider = Provider<CreateKategoriUsecase>((ref) {
  return CreateKategoriUsecase(ref.watch(kategoriIuranRepositoryProvider));
});

final deleteKategoriUsecaseProvider = Provider<DeleteKategoriUsecase>((ref) {
  return DeleteKategoriUsecase(ref.watch(kategoriIuranRepositoryProvider));
});

final getAllKategoriUsecaseProvider = Provider<GetAllKategoriUsecase>((ref) {
  return GetAllKategoriUsecase(ref.watch(kategoriIuranRepositoryProvider));
});

final getKategoriByIdUsecaseProvider = Provider<GetKategoriByIdUsecase>((ref) {
  return GetKategoriByIdUsecase(ref.watch(kategoriIuranRepositoryProvider));
});

final updateKategoriUsecaseProvider = Provider<UpdateKategoriUsecase>((ref) {
  return UpdateKategoriUsecase(ref.watch(kategoriIuranRepositoryProvider));
});


// ------------------------------------------------------------
// NOTIFIER UNTUK LIST DATA (READ, CREATE, UPDATE, DELETE)
// ------------------------------------------------------------
class KategoriIuranNotifier extends StateNotifier<AsyncValue<List<KategoriIuran>>> {
  final GetAllKategoriUsecase getAll;
  final CreateKategoriUsecase create;
  final UpdateKategoriUsecase update;
  final DeleteKategoriUsecase delete;

  KategoriIuranNotifier({
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

  Future<void> addKategori(KategoriIuran data) async {
    try {
      await create(data);
      await loadData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateKategori(int id, KategoriIuran data) async {
    try {
      await update(id, data);
      await loadData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deleteKategoriById(int id) async {
    try {
      await delete(id);
      await loadData();
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final kategoriIuranNotifierProvider = StateNotifierProvider<
    KategoriIuranNotifier, AsyncValue<List<KategoriIuran>>>((ref) {
  return KategoriIuranNotifier(
    getAll: ref.watch(getAllKategoriUsecaseProvider),
    create: ref.watch(createKategoriUsecaseProvider),
    update: ref.watch(updateKategoriUsecaseProvider),
    delete: ref.watch(deleteKategoriUsecaseProvider),
  );
});
