import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';

class SearchRumah {
  final RumahRepository repository;

  SearchRumah(this.repository);

  Future<List<Rumah>> call(String keyword) async {
    return await repository.searchRumah(keyword);
  }
}
