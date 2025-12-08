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
      namaPengeluaran: data.namaPengeluaran,
      jumlah: data.jumlah,
      tanggalPengeluaran: data.tanggalPengeluaran,
      kategoriPengeluaran: data.kategoriPengeluaran,
      buktiPengeluaran: data.buktiPengeluaran,
    ));
  }

  @override
  Future<void> updatePengeluaran(Pengeluaran data) async {
    await datasource.update(PengeluaranModel(
      id: data.id,
      namaPengeluaran: data.namaPengeluaran,
      jumlah: data.jumlah,
      tanggalPengeluaran: data.tanggalPengeluaran,
      kategoriPengeluaran: data.kategoriPengeluaran,
      buktiPengeluaran: data.buktiPengeluaran,
    ));
  }

  @override
  Future<void> deletePengeluaran(int id) async {
    await datasource.delete(id);
  }
}
