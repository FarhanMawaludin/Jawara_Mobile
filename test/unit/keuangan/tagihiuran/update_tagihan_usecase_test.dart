import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/tagihiuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/tagihiuran/update_tagihan_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTagihIuranRepository extends Mock implements TagihIuranRepository {}

void main() {
  late MockTagihIuranRepository mockRepository;
  late UpdateTagihanUsecase usecase;

  setUp(() {
    mockRepository = MockTagihIuranRepository();
    usecase = UpdateTagihanUsecase(mockRepository);
  });

  test('should call repository.updateTagihan correctly', () async {
    const id = 1;
    final updated = TagihIuran(
      id: id,
      createdAt: DateTime.now(),
      kategoriId: 1,
      jumlah: 150000.0,
      tanggalTagihan: DateTime.now(),
      buktiBayar: 'bukti_bayar.jpg',
      nama: 'Iuran Bulanan Updated',
      statusTagihan: 'Sudah Bayar',
      tanggalBayar: DateTime.now(),
    );

    when(
      () => mockRepository.updateTagihan(id, updated),
    ).thenAnswer((_) async => Future.value(true));

    final result = await usecase(id, updated);

    expect(result, true);
    verify(() => mockRepository.updateTagihan(id, updated)).called(1);
  });

  test('should return false when update fails', () async {
    const id = 1;
    final updated = TagihIuran(
      id: id,
      createdAt: DateTime.now(),
      kategoriId: 1,
      jumlah: 150000.0,
      tanggalTagihan: DateTime.now(),
      buktiBayar: 'bukti_bayar.jpg',
      nama: 'Iuran Bulanan Updated',
      statusTagihan: 'Sudah Bayar',
      tanggalBayar: DateTime.now(),
    );

    when(
      () => mockRepository.updateTagihan(id, updated),
    ).thenAnswer((_) async => Future.value(false));

    final result = await usecase(id, updated);

    expect(result, false);
    verify(() => mockRepository.updateTagihan(id, updated)).called(1);
  });
}
