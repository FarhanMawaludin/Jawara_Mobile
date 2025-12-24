import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/metodepembayaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/metodepembayaran/delete_metode_pembayaran.dart';
import 'package:mocktail/mocktail.dart';

class MockMetodePembayaranRepository extends Mock
    implements MetodePembayaranRepository {}

void main() {
  late MockMetodePembayaranRepository mockRepository;
  late DeleteMetodePembayaran usecase;

  setUp(() {
    mockRepository = MockMetodePembayaranRepository();
    usecase = DeleteMetodePembayaran(mockRepository);
  });

  test('should call repository.deleteMetode correctly', () async {
    const id = 1;

    when(
      () => mockRepository.deleteMetode(id),
    ).thenAnswer((_) async => Future.value());

    await usecase(id);

    verify(() => mockRepository.deleteMetode(id)).called(1);
  });
}
