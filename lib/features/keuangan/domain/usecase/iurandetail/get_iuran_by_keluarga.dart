import 'package:jawaramobile/features/keuangan/domain/repositories/iurandetail_repository.dart';
import 'package:jawaramobile/features/keuangan/data/models/iurandetail_model.dart';

class GetIuranByKeluarga {
  final IuranDetailRepository repository;

  GetIuranByKeluarga(this.repository);

  Future<List<IuranDetail>> call(int keluargaId) {
    return repository.getByKeluarga(keluargaId);
  }
}
