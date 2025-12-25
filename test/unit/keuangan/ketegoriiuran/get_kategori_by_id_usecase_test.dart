import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/kategoriiuran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/kategori_iuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/ketegoriiuran/get_kategori_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockKategoriIuranRepository extends Mock
    implements KategoriIuranRepository {}

void main() {
  late MockKategoriIuranRepository mockRepository;
  late GetKategoriByIdUsecase usecase;

  setUp(() {
    mockRepository = MockKategoriIuranRepository();
    usecase = GetKategoriByIdUsecase(mockRepository);
  });

  test('should call repository.getKategoriById correctly', () async {
    const id = 1;
    final expectedKategori = KategoriIuranModel(
      id: id,
      namaKategori: 'Iuran Kebersihan',
      kategoriIuran: 'Iuran Bulanan',
      nominal: 50000.0,
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.getKategoriById(id),
    ).thenAnswer((_) async => Future.value(expectedKategori));

    final result = await usecase(id);

    expect(result, expectedKategori);
    verify(() => mockRepository.getKategoriById(id)).called(1);
  });
}
