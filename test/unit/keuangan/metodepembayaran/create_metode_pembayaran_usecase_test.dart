import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/metodepembayaran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/metodepembayaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/metodepembayaran/create_metode_pembayaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMetodePembayaranRepository extends Mock
    implements MetodePembayaranRepository {}

void main() {
  late MockMetodePembayaranRepository mockRepository;
  late CreateMetodePembayaranUsecase usecase;

  setUp(() {
    mockRepository = MockMetodePembayaranRepository();
    usecase = CreateMetodePembayaranUsecase(mockRepository);
  });

  test('should call repository.createMetode correctly', () async {
    final metode = MetodePembayaranModel(
      namaMetode: 'BCA',
      tipe: 'bank',
      nomorRekening: 1234567890,
      namaPemilik: 'John Doe',
      fotoBarcode: null,
      thumbnail: 'bca_thumbnail.png',
      catatan: 'Rekening utama',
    );

    when(
      () => mockRepository.createMetode(metode),
    ).thenAnswer((_) async => Future.value());

    await usecase(metode);

    verify(() => mockRepository.createMetode(metode)).called(1);
  });
}
