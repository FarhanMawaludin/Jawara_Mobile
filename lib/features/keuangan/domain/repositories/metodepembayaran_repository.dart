import 'package:jawaramobile/features/keuangan/data/models/metodepembayaran_model.dart';
abstract class MetodePembayaranRepository {
  Future<List<MetodePembayaranModel>> getAllMetode();
  Future<MetodePembayaranModel?> getMetodeById(int id);
  Future<void> createMetode(MetodePembayaranModel data);
  Future<void> updateMetode(MetodePembayaranModel data);
  Future<void> deleteMetode(int id);
}