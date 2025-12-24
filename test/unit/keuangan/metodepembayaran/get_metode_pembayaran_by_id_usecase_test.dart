import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/metodepembayaran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/metodepembayaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/metodepembayaran/get_metode_pembayaran_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMetodePembayaranRepository extends Mock
    implements MetodePembayaranRepository {}

void main() {
  late MockMetodePembayaranRepository mockRepository;
  late GetMetodePembayaranByIdUsecase usecase;

  setUp(() {
    mockRepository = MockMetodePembayaranRepository();
    usecase = GetMetodePembayaranByIdUsecase(mockRepository);
  });

  test('should call repository.getMetodeById correctly', () async {
    const id = 1;
    final expectedMetode = MetodePembayaranModel(
      id: id,
      namaMetode: 'BCA',
      tipe: 'bank',
      nomorRekening: 1234567890,
      namaPemilik: 'John Doe',
      fotoBarcode: null,
      thumbnail: 'bca_thumbnail.png',
      catatan: 'Rekening utama',
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.getMetodeById(id),
    ).thenAnswer((_) async => Future.value(expectedMetode));

    final result = await usecase(id);

    expect(result, expectedMetode);
    verify(() => mockRepository.getMetodeById(id)).called(1);
  });
}
