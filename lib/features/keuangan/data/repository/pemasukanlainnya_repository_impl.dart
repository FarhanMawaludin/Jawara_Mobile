import '../../domain/entities/pemasukanlainnya.dart';
import '../../domain/repositories/pemasukanlainnya_repository.dart';
import '../datasources/pemasukanlainnya_remote_datasource.dart';
import '../models/pemasukanlainnya_model.dart' as model;

class PemasukanLainnyaRepositoryImpl implements PemasukanLainnyaRepository {
  final PemasukanLainnyaDatasource datasource;

  PemasukanLainnyaRepositoryImpl(this.datasource);

  @override
  Future<List<PemasukanLainnya>> getAllPemasukan() async {
    final result = await datasource.getAll(); // List<Model>
    return result; // karena Model extend Entity
  }

  @override
  Future<PemasukanLainnya?> getPemasukanById(int id) async {
    final result = await datasource.getById(id);
    return result; // nullable Model yang extend Entity
  }

  @override
  Future<void> createPemasukan(PemasukanLainnya data) async {
    final dataModel = model.PemasukanLainnyaModel(
      id: data.id,
      namaPemasukan: data.namaPemasukan,
      kategoriPemasukan: data.kategoriPemasukan,
      tanggalPemasukan: data.tanggalPemasukan,
      jumlah: data.jumlah,
      buktiPemasukan: data.buktiPemasukan,
    );

    await datasource.insert(dataModel);
  }

  @override
  Future<void> updatePemasukan(PemasukanLainnya data) async {
    final dataModel = model.PemasukanLainnyaModel(
      id: data.id,
      namaPemasukan: data.namaPemasukan,
      kategoriPemasukan: data.kategoriPemasukan,
      tanggalPemasukan: data.tanggalPemasukan,
      jumlah: data.jumlah,
      buktiPemasukan: data.buktiPemasukan,
    );

    await datasource.update(dataModel);
  }

  @override
  Future<void> deletePemasukan(int id) async {
    await datasource.delete(id);
  }
}
