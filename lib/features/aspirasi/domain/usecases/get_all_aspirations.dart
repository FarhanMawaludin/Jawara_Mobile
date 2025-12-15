import '../entities/aspiration.dart';
import '../repositories/aspiration_repository.dart';

class GetAllAspirations {
  final AspirationRepository repository;

  GetAllAspirations(this.repository);

  Future<List<Aspiration>> call() async {
    return await repository.getAllAspirations();
  }
}
