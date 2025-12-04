import 'package:jawaramobile/features/keuangan/domain/entities/pengeluaran.dart';

abstract class PengeluaranRepository {
  Future<List<Pengeluaran>> getAllPengeluaran();
  Future<Pengeluaran?> getPengeluaranById(int id);
  Future<void> createPengeluaran(Pengeluaran data);
  Future<void> updatePengeluaran(Pengeluaran data);
  Future<void> deletePengeluaran(int id);
}
