import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/iurandetail_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/iurandetail_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/iurandetail/update_iuran_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockIuranDetailRepository extends Mock implements IuranDetailRepository {}

void main() {
  late MockIuranDetailRepository mockRepository;
  late UpdateIuranDetail usecase;

  setUp(() {
    mockRepository = MockIuranDetailRepository();
    usecase = UpdateIuranDetail(mockRepository);
  });

  test('should call repository.update correctly', () async {
    final iuranDetail = IuranDetail(
      id: 1,
      keluargaId: 12,
      tagihIuran: 1,
      metodePembayaranId: 2, // Updated value
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.update(iuranDetail),
    ).thenAnswer((_) async => Future.value(true));

    final result = await usecase(iuranDetail);

    expect(result, true);
    verify(() => mockRepository.update(iuranDetail)).called(1);
  });
}
