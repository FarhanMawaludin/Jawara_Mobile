import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/tagihiuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/tagihiuran/create_tagihan_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTagihIuranRepository extends Mock implements TagihIuranRepository {}

void main() {
  late MockTagihIuranRepository mockRepository;
  late CreateTagihanUsecase usecase;

  setUp(() {
    mockRepository = MockTagihIuranRepository();
    usecase = CreateTagihanUsecase(mockRepository);
  });

  test(
    'should call repository.createTagihanForAllKeluarga correctly',
    () async {
      const kategoriId = 1;
      const nama = 'Iuran Bulanan';
      const jumlah = 100000;

      when(
        () => mockRepository.createTagihanForAllKeluarga(
          kategoriId: kategoriId,
          nama: nama,
          jumlah: jumlah,
        ),
      ).thenAnswer((_) async => Future.value());

      await usecase(kategoriId: kategoriId, nama: nama, jumlah: jumlah);

      verify(
        () => mockRepository.createTagihanForAllKeluarga(
          kategoriId: kategoriId,
          nama: nama,
          jumlah: jumlah,
        ),
      ).called(1);
    },
  );

  test('should throw exception when nama is empty', () async {
    expect(
      () => usecase(kategoriId: 1, nama: '', jumlah: 100000),
      throwsException,
    );
  });

  test('should throw exception when jumlah is negative', () async {
    expect(
      () => usecase(kategoriId: 1, nama: 'Iuran Bulanan', jumlah: -100000),
      throwsException,
    );
  });
}
