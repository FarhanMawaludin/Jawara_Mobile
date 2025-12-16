import '../../domain/entities/aspiration.dart';
import '../../domain/repositories/aspiration_repository.dart';
import '../datasources/aspiration_remote_datasource.dart';

class AspirationRepositoryImpl implements AspirationRepository {
  final AspirationRemoteDataSource remoteDataSource;

  AspirationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Aspiration>> getAllAspirations() async {
    final result = await remoteDataSource.getAllAspirations();
    return result; // AspirationModel extends Aspiration
  }
}