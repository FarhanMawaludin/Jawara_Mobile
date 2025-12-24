import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pemasukanlainnya.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pemasukanlainnya_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pemasukanlainnya/create_pemasukanlainnya_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPemasukanLainnyaRepository extends Mock
    implements PemasukanLainnyaRepository {}

void main() {
  late MockPemasukanLainnyaRepository mockRepository;
  late CreatePemasukanUsecase usecase;

  setUp(() {
    mockRepository = MockPemasukanLainnyaRepository();
    usecase = CreatePemasukanUsecase(mockRepository);
  });

  test('should call repository.createPemasukan correctly', () async {
    final pemasukan = PemasukanLainnya(
      id: 1,
      createdAt: DateTime.now(),
      namaPemasukan: 'Donasi',
      kategoriPemasukan: 'Donasi',
      tanggalPemasukan: DateTime.now(),
      jumlah: 100000.0,
      buktiPemasukan: 'donasi_bukti.jpg',
    );

    when(
      () => mockRepository.createPemasukan(pemasukan),
    ).thenAnswer((_) async => Future.value());

    await usecase(pemasukan);

    verify(() => mockRepository.createPemasukan(pemasukan)).called(1);
  });
}
