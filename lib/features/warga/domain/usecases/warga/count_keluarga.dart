import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

class CountKeluarga {
  WargaRepository repository;

  CountKeluarga(this.repository);

  Future<int> call() async => await repository.countKeluarga();
}