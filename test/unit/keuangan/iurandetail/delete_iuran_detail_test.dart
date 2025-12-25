import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/iurandetail_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/iurandetail/delete_iuran_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockIuranDetailRepository extends Mock implements IuranDetailRepository {}

void main() {
  late MockIuranDetailRepository mockRepository;
  late DeleteIuranDetail usecase;

  setUp(() {
    mockRepository = MockIuranDetailRepository();
    usecase = DeleteIuranDetail(mockRepository);
  });

  test('should call repository.delete correctly', () async {
    const id = 1;

    when(
      () => mockRepository.delete(id),
    ).thenAnswer((_) async => Future.value(true));

    final result = await usecase(id);

    expect(result, true);
    verify(() => mockRepository.delete(id)).called(1);
  });
}
