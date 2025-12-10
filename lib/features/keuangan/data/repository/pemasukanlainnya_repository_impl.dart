import 'dart:io';
import '../../domain/entities/pemasukanlainnya.dart';
import '../../domain/repositories/pemasukanlainnya_repository.dart';
import '../datasources/pemasukanlainnya_remote_datasource.dart';
import '../models/pemasukanlainnya_model.dart' as model;

class PemasukanLainnyaRepositoryImpl implements PemasukanLainnyaRepository {
  final PemasukanLainnyaDatasource datasource;

  PemasukanLainnyaRepositoryImpl(this.datasource);

  @override
  Future<List<PemasukanLainnya>> getAllPemasukan() async {
    final result = await datasource.getAll();
    return result;
  }

  @override
  Future<PemasukanLainnya?> getPemasukanById(int id) async {
    final result = await datasource.getById(id);
    return result;
  }

  @override
  Future<void> createPemasukan(PemasukanLainnya data) async {
    String buktiUrl = data.buktiPemasukan;

    // Upload file ke Supabase Storage jika ada path lokal
    if (data.buktiPemasukan.isNotEmpty && 
        File(data.buktiPemasukan).existsSync()) {
      try {
        final file = File(data.buktiPemasukan);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        buktiUrl = await datasource.uploadBukti(file, fileName);
      } catch (e) {
        // Jika upload gagal, tampilkan error ke user
        rethrow;
      }
    }

    final dataModel = model.PemasukanLainnyaModel(
      id: data.id,
      createdAt: data.createdAt,
      namaPemasukan: data.namaPemasukan,
      kategoriPemasukan: data.kategoriPemasukan,
      tanggalPemasukan: data.tanggalPemasukan,
      jumlah: data.jumlah,
      buktiPemasukan: buktiUrl,
    );

    await datasource.insert(dataModel);
  }

  @override
  Future<void> updatePemasukan(PemasukanLainnya data) async {
    String buktiUrl = data.buktiPemasukan;

    // Upload file ke Supabase Storage jika ada path lokal
    if (data.buktiPemasukan.isNotEmpty && 
        File(data.buktiPemasukan).existsSync()) {
      try {
        final file = File(data.buktiPemasukan);
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        buktiUrl = await datasource.uploadBukti(file, fileName);
      } catch (e) {
        // Jika upload gagal, tampilkan error ke user
        rethrow;
      }
    }

    final dataModel = model.PemasukanLainnyaModel(
      id: data.id,
      createdAt: data.createdAt,
      namaPemasukan: data.namaPemasukan,
      kategoriPemasukan: data.kategoriPemasukan,
      tanggalPemasukan: data.tanggalPemasukan,
      jumlah: data.jumlah,
      buktiPemasukan: buktiUrl,
    );

    await datasource.update(dataModel);
  }

  @override
  Future<void> deletePemasukan(int id) async {
    await datasource.delete(id);
  }
}
