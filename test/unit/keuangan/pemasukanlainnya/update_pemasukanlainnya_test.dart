import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pemasukanlainnya.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pemasukanlainnya_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pemasukanlainnya/update_pemasukanlainnya.dart';
import 'package:mocktail/mocktail.dart';

class MockPemasukanLainnyaRepository extends Mock
    implements PemasukanLainnyaRepository {}

void main() {
  late MockPemasukanLainnyaRepository mockRepository;
  late UpdatePemasukanUsecase usecase;

  setUp(() {
    mockRepository = MockPemasukanLainnyaRepository();
    usecase = UpdatePemasukanUsecase(mockRepository);
  });

  test('should call repository.updatePemasukan correctly', () async {
    final updated = PemasukanLainnya(
      id: 1,
      createdAt: DateTime.now(),
      namaPemasukan: 'Donasi Update',
      kategoriPemasukan: 'Donasi',
      tanggalPemasukan: DateTime.now(),
      jumlah: 150000.0,
      buktiPemasukan: 'donasi_update.jpg',
    );

    when(
      () => mockRepository.updatePemasukan(updated),
    ).thenAnswer((_) async => Future.value());

    await usecase(updated);

    verify(() => mockRepository.updatePemasukan(updated)).called(1);
  });
}
