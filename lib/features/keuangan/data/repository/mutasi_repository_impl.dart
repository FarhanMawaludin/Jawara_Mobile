import '../../domain/entities/mutasi.dart';
import '../../domain/repositories/mutasi_repository.dart';
import '../models/mutasi_model.dart';


/// `pemasukanDatasource.getAll` dan `pengeluaranDatasource.getAll`.
class MutasiRepositoryImpl implements MutasiRepository {
  final Future<List<Map<String, dynamic>>> Function() fetchPemasukan;
  final Future<List<Map<String, dynamic>>> Function() fetchPengeluaran;


  MutasiRepositoryImpl({
    required this.fetchPemasukan,
    required this.fetchPengeluaran,
  });


  Future<List<Mutasi>> getAllMutasi() async {
    final pemasukanRows = await fetchPemasukan();
    final pengeluaranRows = await fetchPengeluaran();


    final pemasukanModels = pemasukanRows
      .map((r) => MutasiModel.fromPemasukan(r))
      .toList();


    final pengeluaranModels = pengeluaranRows
    .map((r) => MutasiModel.fromPengeluaran(r))
    .toList();


    final all = [...pemasukanModels, ...pengeluaranModels];


  // Urutkan descending berdasarkan tanggal
    all.sort((a, b) => b.tanggal.compareTo(a.tanggal));
  return all;
  }
}