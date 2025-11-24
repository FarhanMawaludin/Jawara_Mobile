import '../entities/aspiration.dart';

abstract class AspirationRepository {
  Future<List<Aspiration>> getAllAspirations();
}
