import '../../domain/entities/pengeluaran.dart';
import '../../domain/repositories/pengeluaran_repository.dart';

import '../datasources/pengeluaran_remote_datasource.dart';
import '../models/pengeluaran_model.dart';

class PengeluaranRepositoryImpl implements PengeluaranRepository {
  final PengeluaranRemoteDatasource datasource;

  PengeluaranRepositoryImpl(this.datasource);

  @override
  Future<List<Pengeluaran>> getAllPengeluaran() async {
    return await datasource.getAll();
  }

  @override
  Future<Pengeluaran?> getPengeluaranById(int id) async {
    return await datasource.getById(id);
  }

  @override
  Future<void> createPengeluaran(Pengeluaran data) async {
    await datasource.insert(PengeluaranModel(
      id: data.id,
      nama: data.nama,
      jumlah: data.jumlah,
      tanggal: data.tanggal,
      catatan: data.catatan,
    ));
  }

  @override
  Future<void> updatePengeluaran(Pengeluaran data) async {
    await datasource.update(PengeluaranModel(
      id: data.id,
      nama: data.nama,
      jumlah: data.jumlah,
      tanggal: data.tanggal,
      catatan: data.catatan,
    ));
  }

  @override
  Future<void> deletePengeluaran(int id) async {
    await datasource.delete(id);
  }
}
