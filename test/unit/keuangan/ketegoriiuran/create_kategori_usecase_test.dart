import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/kategori_iuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/ketegoriiuran/create_kategori_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockKategoriIuranRepository extends Mock
    implements KategoriIuranRepository {}

void main() {
  late MockKategoriIuranRepository mockRepository;
  late CreateKategoriUsecase usecase;

  setUp(() {
    mockRepository = MockKategoriIuranRepository();
    usecase = CreateKategoriUsecase(mockRepository);
  });

  test('should call repository.createKategori correctly', () async {
    final kategori = KategoriIuranModel(
      namaKategori: 'Iuran Kebersihan',
      kategoriIuran: 'Iuran Bulanan',
      nominal: 50000.0,
    );

    final expectedResult = KategoriIuranModel(
      id: 1,
      namaKategori: 'Iuran Kebersihan',
      kategoriIuran: 'Iuran Bulanan',
      nominal: 50000.0,
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.createKategori(kategori),
    ).thenAnswer((_) async => Future.value(expectedResult));

    final result = await usecase(kategori);

    expect(result, expectedResult);
    verify(() => mockRepository.createKategori(kategori)).called(1);
  });
}
