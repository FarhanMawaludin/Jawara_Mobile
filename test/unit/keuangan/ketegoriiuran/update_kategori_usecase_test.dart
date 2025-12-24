import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/kategori_iuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/ketegoriiuran/update_kategori_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockKategoriIuranRepository extends Mock
    implements KategoriIuranRepository {}

void main() {
  late MockKategoriIuranRepository mockRepository;
  late UpdateKategoriUsecase usecase;

  setUp(() {
    mockRepository = MockKategoriIuranRepository();
    usecase = UpdateKategoriUsecase(mockRepository);
  });

  test('should call repository.updateKategori correctly', () async {
    const id = 1;
    final updatedKategori = KategoriIuranModel(
      namaKategori: 'Iuran Kebersihan Updated',
      kategoriIuran: 'Iuran Bulanan',
      nominal: 60000.0,
    );

    final expectedResult = KategoriIuranModel(
      id: 1,
      namaKategori: 'Iuran Kebersihan Updated',
      kategoriIuran: 'Iuran Bulanan',
      nominal: 60000.0,
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.updateKategori(id, updatedKategori),
    ).thenAnswer((_) async => Future.value(expectedResult));

    final result = await usecase(id, updatedKategori);

    expect(result, expectedResult);
    verify(() => mockRepository.updateKategori(id, updatedKategori)).called(1);
  });
}
