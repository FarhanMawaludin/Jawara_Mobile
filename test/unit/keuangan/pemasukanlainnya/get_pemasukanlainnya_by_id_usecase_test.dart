import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pemasukanlainnya.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pemasukanlainnya_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pemasukanlainnya/get_pemasukanlainnya_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPemasukanLainnyaRepository extends Mock
    implements PemasukanLainnyaRepository {}

void main() {
  late MockPemasukanLainnyaRepository mockRepository;
  late GetPemasukanByIdUsecase usecase;

  setUp(() {
    mockRepository = MockPemasukanLainnyaRepository();
    usecase = GetPemasukanByIdUsecase(mockRepository);
  });

  test('should call repository.getPemasukanById correctly', () async {
    const id = 1;
    final expected = PemasukanLainnya(
      id: id,
      createdAt: DateTime.now(),
      namaPemasukan: 'Donasi',
      kategoriPemasukan: 'Donasi',
      tanggalPemasukan: DateTime.now(),
      jumlah: 150000.0,
      buktiPemasukan: 'bukti_donasi.jpg',
    );

    when(
      () => mockRepository.getPemasukanById(id),
    ).thenAnswer((_) async => expected);

    final result = await usecase(id);

    expect(result, expected);
    verify(() => mockRepository.getPemasukanById(id)).called(1);
  });
}
