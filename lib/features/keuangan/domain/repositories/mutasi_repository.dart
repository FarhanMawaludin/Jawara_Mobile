import '../entities/mutasi.dart';


abstract class MutasiRepository {
Future<List<Mutasi>> getAllMutasi();
}