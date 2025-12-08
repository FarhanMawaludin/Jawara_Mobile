import 'package:jawaramobile/features/keuangan/data/models/metodepembayaran_model.dart';
abstract class MetodePembayaranRepository {
  Future<List<MetodePembayaran>> getAllMetode();
  Future<MetodePembayaran?> getMetodeById(int id);
  Future<bool> createMetode(MetodePembayaran data);
  Future<bool> updateMetode(MetodePembayaran data);
  Future<bool> deleteMetode(int id);
}
