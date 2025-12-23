import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/iurandetail_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/iurandetail_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/iurandetail/get_iuran_by_keluarga.dart';
import 'package:mocktail/mocktail.dart';

class MockIuranDetailRepository extends Mock implements IuranDetailRepository {}

void main() {
  late MockIuranDetailRepository mockRepository;
  late GetIuranByKeluarga usecase;

  setUp(() {
    mockRepository = MockIuranDetailRepository();
    usecase = GetIuranByKeluarga(mockRepository);
  });

  test('should call repository.getByKeluarga correctly', () async {
    const keluargaId = 12;
    final expectedList = [
      IuranDetail(
        id: 1,
        keluargaId: keluargaId,
        tagihIuran: 1,
        metodePembayaranId: 1,
        createdAt: DateTime.now(),
      ),
      IuranDetail(
        id: 2,
        keluargaId: keluargaId,
        tagihIuran: 2,
        metodePembayaranId: 2,
        createdAt: DateTime.now(),
      ),
    ];

    when(
      () => mockRepository.getByKeluarga(keluargaId),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase(keluargaId);

    expect(result, expectedList);
    verify(() => mockRepository.getByKeluarga(keluargaId)).called(1);
  });
}
