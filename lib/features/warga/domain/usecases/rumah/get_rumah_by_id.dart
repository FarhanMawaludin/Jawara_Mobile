import 'package:jawaramobile/features/warga/data/models/rumah_model.dart';
import '../../repositories/rumah_repository.dart';

class GetRumahById {
  final RumahRepository repository;

  GetRumahById(this.repository);

  Future<RumahModel?> call(int id) {
    return repository.getRumahById(id);
  }
}
