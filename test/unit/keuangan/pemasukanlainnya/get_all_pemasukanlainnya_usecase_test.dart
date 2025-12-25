import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pemasukanlainnya.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pemasukanlainnya_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pemasukanlainnya/get_all_pemasukanlainnya_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPemasukanLainnyaRepository extends Mock
    implements PemasukanLainnyaRepository {}

void main() {
  late MockPemasukanLainnyaRepository mockRepository;
  late GetAllPemasukanLainnyaUsecase usecase;

  setUp(() {
    mockRepository = MockPemasukanLainnyaRepository();
    usecase = GetAllPemasukanLainnyaUsecase(mockRepository);
  });

  test('should call repository.getAllPemasukan correctly', () async {
    final expectedList = [
      PemasukanLainnya(
        id: 1,
        createdAt: DateTime.now(),
        namaPemasukan: 'Donasi',
        kategoriPemasukan: 'Donasi',
        tanggalPemasukan: DateTime.now(),
        jumlah: 50000.0,
        buktiPemasukan: 'donasi_bukti.jpg',
      ),
      PemasukanLainnya(
        id: 2,
        createdAt: DateTime.now(),
        namaPemasukan: 'Parkir',
        kategoriPemasukan: 'Parkir',
        tanggalPemasukan: DateTime.now(),
        jumlah: 25000.0,
        buktiPemasukan: 'parkir_bukti.jpg',
      ),
    ];

    when(
      () => mockRepository.getAllPemasukan(),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase();

    expect(result, expectedList);
    verify(() => mockRepository.getAllPemasukan()).called(1);
  });
}
