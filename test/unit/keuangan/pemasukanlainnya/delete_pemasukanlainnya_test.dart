import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pemasukanlainnya_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pemasukanlainnya/delete_pemasukanlainnya.dart';
import 'package:mocktail/mocktail.dart';

class MockPemasukanLainnyaRepository extends Mock
    implements PemasukanLainnyaRepository {}

void main() {
  late MockPemasukanLainnyaRepository mockRepository;
  late DeletePemasukanLainnyaUsecase usecase;

  setUp(() {
    mockRepository = MockPemasukanLainnyaRepository();
    usecase = DeletePemasukanLainnyaUsecase(mockRepository);
  });

  test('should call repository.deletePemasukan correctly', () async {
    const id = 1;

    when(
      () => mockRepository.deletePemasukan(id),
    ).thenAnswer((_) async => Future.value());

    await usecase(id);

    verify(() => mockRepository.deletePemasukan(id)).called(1);
  });
}
