import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/iurandetail_model.dart';
import '../../../data/repository/iurandetail_repository_impl.dart';
import '../../../data/datasources/iurandetail_remote_datasource.dart';
import '../../../domain/repositories/iurandetail_repository.dart';
import '../../../domain/usecase/iurandetail/create_iuran_detail.dart';
import '../../../domain/usecase/iurandetail/update_iuran_detail.dart';
import '../../../domain/usecase/iurandetail/delete_iuran_detail.dart';
import '../../../domain/usecase/iurandetail/get_iuran_by_keluarga.dart';

//===============================================================================
// Data Source Provider
//===============================================================================
final iuranDetailDatasourceProvider = Provider<IuranDetailDatasource>((ref) {
  return IuranDetailDatasource();
});

//===============================================================================
// Repository Provider
//===============================================================================
final iuranDetailRepositoryProvider = Provider<IuranDetailRepository>((ref) {
  return IuranDetailRepositoryImpl(
    datasource: ref.watch(iuranDetailDatasourceProvider),
  );
});

//===============================================================================
// Usecase Providers
//===============================================================================

/// GET BY KELUARGA
final getIuranByKeluargaProvider = Provider<GetIuranByKeluarga>((ref) {
  return GetIuranByKeluarga(
    ref.read(iuranDetailRepositoryProvider),
  );
});

/// CREATE
final createIuranDetailProvider = Provider<CreateIuranDetail>((ref) {
  return CreateIuranDetail(
    ref.read(iuranDetailRepositoryProvider),
  );
});

/// UPDATE
final updateIuranDetailProvider = Provider<UpdateIuranDetail>((ref) {
  return UpdateIuranDetail(
    ref.read(iuranDetailRepositoryProvider),
  );
});

/// DELETE
final deleteIuranDetailProvider = Provider<DeleteIuranDetail>((ref) {
  return DeleteIuranDetail(
    ref.read(iuranDetailRepositoryProvider),
  );
});

//===============================================================================
// Family Provider untuk get iuran detail by keluarga
//===============================================================================
final iuranDetailByKeluargaProvider =
    FutureProvider.family<List<IuranDetail>, int>((ref, keluargaId) async {
  try {
    print('🔍 [Provider] Fetching iuran detail for keluargaId: $keluargaId');
    
    // ✅ PERBAIKAN: Pakai usecase, bukan datasource
    final usecase = ref. watch(getIuranByKeluargaProvider);
    final result = await usecase(keluargaId);
    
    print('✅ [Provider] Fetched ${result.length} records');
    
    return result;
  } catch (e, st) {
    print('❌ [Provider] Error:  $e');
    print('📍 StackTrace: $st');
    rethrow;
  }
});

//===============================================================================
// Notifier for Iuran Detail List
//===============================================================================
class IuranDetailNotifier extends StateNotifier<AsyncValue<List<IuranDetail>>> {
  final GetIuranByKeluarga getByKeluarga;
  final CreateIuranDetail create;
  final UpdateIuranDetail update;
  final DeleteIuranDetail delete;

  IuranDetailNotifier({
    required this.getByKeluarga,
    required this.create,
    required this.update,
    required this.delete,
  }) : super(const AsyncValue.loading());

  Future<void> fetchByKeluarga(int keluargaId) async {
    try {
      print('🔄 [Notifier] Loading data for keluargaId: $keluargaId');
      state = const AsyncValue.loading();
      
      final data = await getByKeluarga(keluargaId);
      
      print('✅ [Notifier] Loaded ${data.length} records');
      state = AsyncValue.data(data);
    } catch (e, st) {
      print('❌ [Notifier] Error:  $e');
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addIuranDetail(IuranDetail data) async {
    try {
      await create(data);
      // Refresh setelah create
    } catch (e) {
      print('❌ [Notifier] Create error: $e');
      rethrow;
    }
  }

  Future<void> editIuranDetail(IuranDetail data) async {
    try {
      await update(data);
      // Refresh setelah update
    } catch (e) {
      print('❌ [Notifier] Update error:  $e');
      rethrow;
    }
  }

  Future<void> removeIuranDetail(int id) async {
    try {
      await delete(id);
      // Refresh setelah delete
    } catch (e) {
      print('❌ [Notifier] Delete error: $e');
      rethrow;
    }
  }
}

//===============================================================================
// Notifier Provider
//===============================================================================
final iuranDetailNotifierProvider =
    StateNotifierProvider<IuranDetailNotifier, AsyncValue<List<IuranDetail>>>(
  (ref) {
    return IuranDetailNotifier(
      getByKeluarga: ref.watch(getIuranByKeluargaProvider),
      create: ref.watch(createIuranDetailProvider),
      update: ref.watch(updateIuranDetailProvider),
      delete: ref.watch(deleteIuranDetailProvider),
    );
  },
);