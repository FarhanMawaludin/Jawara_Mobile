import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';

class CreateMutasi {
  final MutasiRepository repository;
  CreateMutasi(this.repository);
  Future<void> call(Mutasi mutasi) async => await repository.createMutasi(mutasi);
}