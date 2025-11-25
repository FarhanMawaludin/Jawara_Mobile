import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';

class SearchMutasi {
  final MutasiRepository repository;

  SearchMutasi(this.repository);

  Future<List<Mutasi>> call(String keyword) async {
    return await repository.searchMutasi(keyword);
  }
}
