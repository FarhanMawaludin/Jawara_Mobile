import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/data/models/metodepembayaran_model.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/metodepembayaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/metodepembayaran/get_all_metode_pembayaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockMetodePembayaranRepository extends Mock
    implements MetodePembayaranRepository {}

void main() {
  late MockMetodePembayaranRepository mockRepository;
  late GetAllMetodePembayaranUsecase usecase;

  setUp(() {
    mockRepository = MockMetodePembayaranRepository();
    usecase = GetAllMetodePembayaranUsecase(mockRepository);
  });

  test('should call repository.getAllMetode correctly', () async {
    final expectedList = [
      MetodePembayaranModel(
        id: 1,
        namaMetode: 'BCA',
        tipe: 'bank',
        nomorRekening: 1234567890,
        namaPemilik: 'John Doe',
        fotoBarcode: null,
        thumbnail: 'bca_thumbnail.png',
        catatan: 'Rekening utama',
        createdAt: DateTime.now(),
      ),
      MetodePembayaranModel(
        id: 2,
        namaMetode: 'GoPay',
        tipe: 'e-wallet',
        nomorRekening: 987654321,
        namaPemilik: 'Jane Smith',
        fotoBarcode: 'gopay_qr.png',
        thumbnail: 'gopay_thumbnail.png',
        catatan: 'E-wallet utama',
        createdAt: DateTime.now(),
      ),
    ];

    when(
      () => mockRepository.getAllMetode(),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase();

    expect(result, expectedList);
    verify(() => mockRepository.getAllMetode()).called(1);
  });
}
