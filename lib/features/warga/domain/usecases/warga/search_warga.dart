import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

class SearchWarga {
  final WargaRepository repository;

  SearchWarga(this.repository);

  Future<List<Warga>> call(String keyword) {
    return repository.searchWarga(keyword);
  }
}
