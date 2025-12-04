//import 'package:jawaramobile/features/keuangan/data/models/pemasukanlainnya_model.dart';
import '../../repositories/pemasukanlainnya_repository.dart';
import '../../entities/pemasukanlainnya.dart';
class GetAllPemasukanUsecase {
  final PemasukanLainnyaRepository repository;

  GetAllPemasukanUsecase(this.repository);

  Future<List<PemasukanLainnya>> call() async {
    return await repository.getAllPemasukan();
  }
}
