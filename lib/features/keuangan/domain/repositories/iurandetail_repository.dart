import 'package:jawaramobile/features/keuangan/data/models/iurandetail_model.dart';
abstract class IuranDetailRepository {
  Future<List<IuranDetail>> getByKeluarga(int keluargaId);

  Future<bool> create(IuranDetail data);

  Future<bool> update(IuranDetail data);

  Future<bool> delete(int id);
}
