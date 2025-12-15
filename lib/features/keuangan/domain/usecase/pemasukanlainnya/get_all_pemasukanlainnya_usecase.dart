//import 'package:jawaramobile/features/keuangan/data/models/pemasukanlainnya_model.dart';
import '../../repositories/pemasukanlainnya_repository.dart';
import '../../entities/pemasukanlainnya.dart';
class GetAllPemasukanLainnyaUsecase {
  final PemasukanLainnyaRepository repository;

  GetAllPemasukanLainnyaUsecase(this.repository);

  Future<List<PemasukanLainnya>> call() async {
    return await repository.getAllPemasukan();
  }
}
