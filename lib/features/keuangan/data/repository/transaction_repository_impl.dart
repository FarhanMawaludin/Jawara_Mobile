import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../models/transaction_model.dart';


/// `pemasukanDatasource.getAll` dan `pengeluaranDatasource.getAll`.
class TransactionRepositoryImpl implements TransactionRepository {
  final Future<List<Map<String, dynamic>>> Function() fetchPemasukan;
  final Future<List<Map<String, dynamic>>> Function() fetchPengeluaran;


  TransactionRepositoryImpl({
    required this.fetchPemasukan,
    required this.fetchPengeluaran,
  });


  @override
  Future<List<Transaction>> getAllTransactions() async {
    final pemasukanRows = await fetchPemasukan();
    final pengeluaranRows = await fetchPengeluaran();


    final pemasukanModels = pemasukanRows
      .map((r) => TransactionModel.fromPemasukan(r))
      .toList();


    final pengeluaranModels = pengeluaranRows
    .map((r) => TransactionModel.fromPengeluaran(r))
    .toList();


    final all = [...pemasukanModels, ...pengeluaranModels];


  // Urutkan descending berdasarkan tanggal
    all.sort((a, b) => b.tanggal.compareTo(a.tanggal));
  return all;
  }
}