import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/tagihiuran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/tagihiuran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/tagihiuran/get_tagihan_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockTagihIuranRepository extends Mock implements TagihIuranRepository {}

void main() {
  late MockTagihIuranRepository mockRepository;
  late GetTagihanByIdUsecase usecase;

  setUp(() {
    mockRepository = MockTagihIuranRepository();
    usecase = GetTagihanByIdUsecase(mockRepository);
  });

  test('should call repository.getTagihanById correctly', () async {
    const id = 1;
    final expectedTagihan = TagihIuran(
      id: id,
      createdAt: DateTime.now(),
      kategoriId: 1,
      jumlah: 100000.0,
      tanggalTagihan: DateTime.now(),
      buktiBayar: null,
      nama: 'Iuran Bulanan',
      statusTagihan: 'Belum Bayar',
      tanggalBayar: null,
    );

    when(
      () => mockRepository.getTagihanById(id),
    ).thenAnswer((_) async => Future.value(expectedTagihan));

    final result = await usecase(id);

    expect(result, expectedTagihan);
    verify(() => mockRepository.getTagihanById(id)).called(1);
  });

  test('should return null when tagihan not found', () async {
    const id = 999;

    when(
      () => mockRepository.getTagihanById(id),
    ).thenAnswer((_) async => Future.value(null));

    final result = await usecase(id);

    expect(result, isNull);
    verify(() => mockRepository.getTagihanById(id)).called(1);
  });
}
