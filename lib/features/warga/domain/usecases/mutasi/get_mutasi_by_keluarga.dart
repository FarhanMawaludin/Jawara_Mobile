import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';

class GetMutasiByKeluarga {
  final MutasiRepository repository;
  GetMutasiByKeluarga(this.repository);
  Future<Mutasi?> call(int keluargaId) async => await repository.getMutasiByKeluarga(keluargaId);
}