import 'dart:io';
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
    String buktiUrl = data.buktiPengeluaran;

    // Upload file ke Supabase Storage jika ada path lokal
    if (data.buktiPengeluaran.isNotEmpty && 
        File(data.buktiPengeluaran).existsSync()) {
      try {
        final file = File(data.buktiPengeluaran);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        buktiUrl = await datasource.uploadBukti(file, fileName);
      } catch (e) {
        rethrow;
      }
    }

    await datasource.insert(PengeluaranModel(
      id: data.id,
      createdAt: data.createdAt,
      namaPengeluaran: data.namaPengeluaran,
      jumlah: data.jumlah,
      tanggalPengeluaran: data.tanggalPengeluaran,
      kategoriPengeluaran: data.kategoriPengeluaran,
      buktiPengeluaran: buktiUrl,
    ));
  }

  @override
  Future<void> updatePengeluaran(Pengeluaran data) async {
    String buktiUrl = data.buktiPengeluaran;

    // Upload file ke Supabase Storage jika ada path lokal
    if (data.buktiPengeluaran.isNotEmpty && 
        File(data.buktiPengeluaran).existsSync()) {
      try {
        final file = File(data.buktiPengeluaran);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        buktiUrl = await datasource.uploadBukti(file, fileName);
      } catch (e) {
        rethrow;
      }
    }

    await datasource.update(PengeluaranModel(
      id: data.id,
      createdAt: data.createdAt,
      namaPengeluaran: data.namaPengeluaran,
      jumlah: data.jumlah,
      tanggalPengeluaran: data.tanggalPengeluaran,
      kategoriPengeluaran: data.kategoriPengeluaran,
      buktiPengeluaran: buktiUrl,
    ));
  }

  @override
  Future<void> deletePengeluaran(int id) async {
    await datasource.delete(id);
  }
}
