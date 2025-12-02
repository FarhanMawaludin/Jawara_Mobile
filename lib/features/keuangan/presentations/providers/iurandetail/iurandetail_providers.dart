import 'package:flutter_riverpod/flutter_riverpod.dart';
//===============================================================================
// Iuran Detail Providers
//===============================================================================
// Repository
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
// End of Iuran Detail Providers  
//===============================================================================