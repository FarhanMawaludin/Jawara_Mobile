import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/kategori_iuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/ketegoriiuran/get_all_kategori_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockKategoriIuranRepository extends Mock
    implements KategoriIuranRepository {}

void main() {
  late MockKategoriIuranRepository mockRepository;
  late GetAllKategoriUsecase usecase;

  setUp(() {
    mockRepository = MockKategoriIuranRepository();
    usecase = GetAllKategoriUsecase(mockRepository);
  });

  test('should call repository.getAllKategori correctly', () async {
    final expectedList = [
      KategoriIuranModel(
        id: 1,
        namaKategori: 'Iuran Kebersihan',
        kategoriIuran: 'Iuran Bulanan',
        nominal: 50000.0,
        createdAt: DateTime.now(),
      ),
      KategoriIuranModel(
        id: 2,
        namaKategori: 'Iuran Keamanan',
        kategoriIuran: 'Iuran Bulanan',
        nominal: 30000.0,
        createdAt: DateTime.now(),
      ),
    ];

    when(
      () => mockRepository.getAllKategori(),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase();

    expect(result, expectedList);
    verify(() => mockRepository.getAllKategori()).called(1);
  });
}
