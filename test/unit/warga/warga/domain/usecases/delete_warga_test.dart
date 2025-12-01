import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/delete_warga.dart';
import 'package:mocktail/mocktail.dart';

class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late DeleteWarga usecase;

  setUp(() {
    mockRepository = MockWargaRepository();
    usecase = DeleteWarga(mockRepository);
  });

  test("DeleteWarga should call repository.deleteWarga", () async {
    when(() => mockRepository.deleteWarga(1))
        .thenAnswer((_) async {});

    await usecase(1);

    verify(() => mockRepository.deleteWarga(1)).called(1);
  });
}
