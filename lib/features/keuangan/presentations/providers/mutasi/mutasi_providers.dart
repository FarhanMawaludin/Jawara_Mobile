import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:jawaramobile/features/keuangan/data/models/mutasi_model.dart';
import 'package:jawaramobile/features/keuangan/data/repository/mutasi_repository_impl.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/transaction/get_all_mutasi.dart';

import '../../../data/models/statistik_model.dart';

/// Provider untuk SupabaseClient (dari Supabase.instance.client)
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Provider untuk fetch pemasukan dari Supabase
final fetchPemasukanProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase.from('pemasukan_lainnya').select();
  return (response as List<dynamic>).cast<Map<String, dynamic>>();
});

/// Provider untuk fetch pengeluaran dari Supabase
final fetchPengeluaranProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final supabase = ref.watch(supabaseClientProvider);
  final response = await supabase.from('pengeluaran').select();
  return (response as List<dynamic>).cast<Map<String, dynamic>>();
});

/// Provider untuk MutasiRepositoryImpl
final mutasiRepositoryProvider = Provider<MutasiRepositoryImpl>((ref) {
  // function yang mengembalikan Future
  Future<List<Map<String, dynamic>>> fetchPemasukan() {
    return ref.read(fetchPemasukanProvider.future); // aman
  }

  Future<List<Map<String, dynamic>>> fetchPengeluaran() {
    return ref.read(fetchPengeluaranProvider.future); // aman
  }

  return MutasiRepositoryImpl(
    fetchPemasukan: fetchPemasukan,
    fetchPengeluaran: fetchPengeluaran,
  );
});

/// Provider untuk GetAllTransactions usecase
final getAllTransactionsProvider = Provider<GetAllMutasi>((ref) {
  final repository = ref.watch(mutasiRepositoryProvider);
  return GetAllMutasi(repository);
});

/// Provider untuk fetch semua transaksi (FutureProvider)
final allTransactionsProvider = FutureProvider<List<Mutasi>>((ref) async {
  final usecase = ref.watch(getAllTransactionsProvider);
  return await usecase.call();
});

/// Provider untuk hitung total saldo (pemasukan - pengeluaran)
final totalSaldoProvider = FutureProvider<double>((ref) async {
  final transaksiBukuAsync = ref.watch(allTransactionsProvider);
  
  return transaksiBukuAsync.when(
    data: (transaksiList) {
      double totalSaldo = 0.0;
      
      for (var transaksi in transaksiList) {
        if (transaksi.jenis == MutasiType.pemasukan) {
          totalSaldo += transaksi.jumlah;
        } else if (transaksi.jenis == MutasiType.pengeluaran) {
          totalSaldo -= transaksi.jumlah;
        }
      }
      
      return totalSaldo;
    },
    loading: () => 0.0,
    error: (_, __) => 0.0,
  );
});

final statistikProvider = FutureProvider<StatistikModel>((ref) async {
  final allTransactionsAsync = ref.watch(allTransactionsProvider);

  return allTransactionsAsync.when(
    loading: () => StatistikModel.empty(),
    error: (_, __) => StatistikModel.empty(),
    data: (transaksiList) {
      double totalPemasukan = 0;
      double totalPengeluaran = 0;

      final pemasukanBulanan = List<double>.filled(12, 0);
      final pengeluaranBulanan = List<double>.filled(12, 0);

      final kategoriPemasukan = <String, double>{};
      final kategoriPengeluaran = <String, double>{};

      for (final t in transaksiList) {
        final bulanIndex = t.tanggal.month - 1;

        if (t.jenis == MutasiType.pemasukan) {
          // total
          totalPemasukan += t.jumlah;

          // bulanan
          pemasukanBulanan[bulanIndex] += t.jumlah;

          // kategori
          final key = t.kategori ?? "-";
          kategoriPemasukan[key] = (kategoriPemasukan[key] ?? 0) + t.jumlah;

        } else {
          // total
          totalPengeluaran += t.jumlah;

          // bulanan
          pengeluaranBulanan[bulanIndex] += t.jumlah;

          // kategori
          final key = t.kategori ?? "-";
          kategoriPengeluaran[key] = (kategoriPengeluaran[key] ?? 0) + t.jumlah;
        }
      }

      return StatistikModel(
        totalPemasukan: totalPemasukan,
        totalPengeluaran: totalPengeluaran,
        pemasukanBulanan: pemasukanBulanan,
        pengeluaranBulanan: pengeluaranBulanan,
        kategoriPemasukan: kategoriPemasukan,
        kategoriPengeluaran: kategoriPengeluaran,
      );
    },
  );
});

