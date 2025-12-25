import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pengeluaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pengeluaran/delete_pengeluaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPengeluaranRepository extends Mock implements PengeluaranRepository {}

void main() {
  late MockPengeluaranRepository mockRepository;
  late DeletePengeluaranUsecase usecase;

  setUp(() {
    mockRepository = MockPengeluaranRepository();
    usecase = DeletePengeluaranUsecase(mockRepository);
  });

  test('should call repository.deletePengeluaran correctly', () async {
    const id = 1;

    when(
      () => mockRepository.deletePengeluaran(id),
    ).thenAnswer((_) async => Future.value());

    await usecase(id);

    verify(() => mockRepository.deletePengeluaran(id)).called(1);
  });
}
