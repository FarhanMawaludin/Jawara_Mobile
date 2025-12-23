import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/metodepembayaran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/metodepembayaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/metodepembayaran/update_metode_pembayaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMetodePembayaranRepository extends Mock
    implements MetodePembayaranRepository {}

void main() {
  late MockMetodePembayaranRepository mockRepository;
  late UpdateMetodePembayaranUsecase usecase;

  setUp(() {
    mockRepository = MockMetodePembayaranRepository();
    usecase = UpdateMetodePembayaranUsecase(mockRepository);
  });

  test('should call repository.updateMetode correctly', () async {
    final metode = MetodePembayaranModel(
      id: 1,
      namaMetode: 'BCA Updated',
      tipe: 'bank',
      nomorRekening: 1234567890,
      namaPemilik: 'John Doe Updated',
      fotoBarcode: null,
      thumbnail: 'bca_thumbnail_updated.png',
      catatan: 'Rekening utama updated',
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.updateMetode(metode),
    ).thenAnswer((_) async => Future.value());

    await usecase(metode);

    verify(() => mockRepository.updateMetode(metode)).called(1);
  });
}
