import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/tagihiuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/tagihiuran/delete_tagihan_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTagihIuranRepository extends Mock implements TagihIuranRepository {}

void main() {
  late MockTagihIuranRepository mockRepository;
  late DeleteTagihanUsecase usecase;

  setUp(() {
    mockRepository = MockTagihIuranRepository();
    usecase = DeleteTagihanUsecase(mockRepository);
  });

  test('should call repository.deleteTagihan correctly', () async {
    const id = 1;

    when(
      () => mockRepository.deleteTagihan(id),
    ).thenAnswer((_) async => Future.value(true));

    final result = await usecase(id);

    expect(result, true);
    verify(() => mockRepository.deleteTagihan(id)).called(1);
  });

  test('should return false when delete fails', () async {
    const id = 1;

    when(
      () => mockRepository.deleteTagihan(id),
    ).thenAnswer((_) async => Future.value(false));

    final result = await usecase(id);

    expect(result, false);
    verify(() => mockRepository.deleteTagihan(id)).called(1);
  });
}
