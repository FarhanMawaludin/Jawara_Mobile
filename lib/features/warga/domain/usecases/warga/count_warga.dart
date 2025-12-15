import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

class CountWarga {
  WargaRepository repository;

  CountWarga(this.repository);

  Future<int> call() async => await repository.countWarga();
}