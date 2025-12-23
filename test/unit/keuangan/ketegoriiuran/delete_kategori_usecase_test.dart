import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/kategori_iuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/ketegoriiuran/delete_kategori_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockKategoriIuranRepository extends Mock
    implements KategoriIuranRepository {}

void main() {
  late MockKategoriIuranRepository mockRepository;
  late DeleteKategoriUsecase usecase;

  setUp(() {
    mockRepository = MockKategoriIuranRepository();
    usecase = DeleteKategoriUsecase(mockRepository);
  });

  test('should call repository.deleteKategori correctly', () async {
    const id = 1;

    when(
      () => mockRepository.deleteKategori(id),
    ).thenAnswer((_) async => Future.value(true));

    final result = await usecase(id);

    expect(result, true);
    verify(() => mockRepository.deleteKategori(id)).called(1);
  });
}
