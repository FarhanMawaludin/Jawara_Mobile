import 'package:flutter_riverpod/flutter_riverpod.dart';
//===============================================================================
// Iuran Detail Providers
//===============================================================================
// Repository
import '../../../data/models/iurandetail_model.dart';
import '../../../data/repository/iurandetail_repository_impl.dart';
import '../../../data/datasources/iurandetail_remote_datasource.dart';
import '../../../domain/repositories/iurandetail_repository.dart';

// Usecases
import '../../../domain/usecase/iurandetail/create_iuran_detail.dart';
import '../../../domain/usecase/iurandetail/update_iuran_detail.dart';
import '../../../domain/usecase/iurandetail/delete_iuran_detail.dart';
import '../../../domain/usecase/iurandetail/get_iuran_by_keluarga.dart';

/// Repository Provider
final iuranDetailRepositoryProvider =
    Provider<IuranDetailRepository>((ref) {
  return IuranDetailRepositoryImpl(
    datasource: IuranDetailDatasource(),
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

/// GET BY KELUARGA
final getIuranByKeluargaProvider =
    Provider<GetIuranByKeluarga>((ref) {
  return GetIuranByKeluarga(
    ref.read(iuranDetailRepositoryProvider),
  );
});


//===============================================================================
// Notifier for Iuran Detail List
//===============================================================================

class IuranDetailNotifier
    extends StateNotifier<AsyncValue<List<IuranDetail>>> {
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
      state = const AsyncValue.loading();
      final data = await getByKeluarga(keluargaId);
      state = AsyncValue.data(data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> addIuranDetail(IuranDetail data) async {
    await create(data);
    // Optionally refresh the list after creation
  }

  Future<void> editIuranDetail(IuranDetail data) async {
    await update(data);
    // Optionally refresh the list after update
  }

  Future<void> removeIuranDetail(int id) async {
    await delete(id);
    // Optionally refresh the list after deletion
  }
}