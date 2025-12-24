import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/tagihiuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/tagihiuran/get_all_tagihan_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTagihIuranRepository extends Mock implements TagihIuranRepository {}

void main() {
  late MockTagihIuranRepository mockRepository;
  late GetAllTagihanUsecase usecase;

  setUp(() {
    mockRepository = MockTagihIuranRepository();
    usecase = GetAllTagihanUsecase(mockRepository);
  });

  test('should call repository.getAllTagihan correctly', () async {
    final expectedList = [
      TagihIuran(
        id: 1,
        createdAt: DateTime.now(),
        kategoriId: 1,
        jumlah: 100000.0,
        tanggalTagihan: DateTime.now(),
        buktiBayar: null,
        nama: 'Iuran Bulanan',
        statusTagihan: 'Belum Bayar',
        tanggalBayar: null,
      ),
      TagihIuran(
        id: 2,
        createdAt: DateTime.now(),
        kategoriId: 2,
        jumlah: 50000.0,
        tanggalTagihan: DateTime.now(),
        buktiBayar: null,
        nama: 'Iuran Keamanan',
        statusTagihan: 'Belum Bayar',
        tanggalBayar: null,
      ),
    ];

    when(
      () => mockRepository.getAllTagihan(),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase();

    expect(result, expectedList);
    verify(() => mockRepository.getAllTagihan()).called(1);
  });
}
