import '../../entities/statistik.dart';
import '../../repositories/warga_repository.dart';

class GetStatistikWarga {
  final WargaRepository repository;

  GetStatistikWarga(this.repository);

  /// Mengembalikan object StatistikWarga yang sudah dibentuk oleh repository.
  /// Gunakan `.call()` dari provider / UI untuk memanggilnya.
  Future<StatistikWarga> call() async {
    return await repository.getStatistikWarga();
  }
}
