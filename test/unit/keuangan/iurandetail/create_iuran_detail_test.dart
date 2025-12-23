import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/iurandetail_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/iurandetail_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/iurandetail/create_iuran_detail.dart';
import 'package:mocktail/mocktail.dart';

class MockIuranDetailRepository extends Mock implements IuranDetailRepository {}

void main() {
  late MockIuranDetailRepository mockRepository;
  late CreateIuranDetail usecase;

  setUp(() {
    mockRepository = MockIuranDetailRepository();
    usecase = CreateIuranDetail(mockRepository);
  });

  test('should call repository.create correctly', () async {
    final iuranDetail = IuranDetail(
      id: 1,
      keluargaId: 12,
      tagihIuran: 1,
      metodePembayaranId: 1,
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.create(iuranDetail),
    ).thenAnswer((_) async => Future.value(true));

    final result = await usecase(iuranDetail);

    expect(result, true);
    verify(() => mockRepository.create(iuranDetail)).called(1);
  });
}
