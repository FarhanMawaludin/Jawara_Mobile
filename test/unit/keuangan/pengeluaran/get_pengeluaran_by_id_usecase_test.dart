import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pengeluaran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pengeluaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pengeluaran/get_pengeluaran_by_id_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPengeluaranRepository extends Mock implements PengeluaranRepository {}

void main() {
  late MockPengeluaranRepository mockRepository;
  late GetPengeluaranByIdUsecase usecase;

  setUp(() {
    mockRepository = MockPengeluaranRepository();
    usecase = GetPengeluaranByIdUsecase(mockRepository);
  });

  test('should call repository.getPengeluaranById correctly', () async {
    const id = 1;
    final expectedPengeluaran = Pengeluaran(
      id: id,
      createdAt: DateTime.now(),
      namaPengeluaran: 'Pembelian alat kebersihan',
      kategoriPengeluaran: 'Operasional',
      tanggalPengeluaran: DateTime.now(),
      jumlah: 75000.0,
      buktiPengeluaran: 'nota_alat_kebersihan.jpg',
    );

    when(
      () => mockRepository.getPengeluaranById(id),
    ).thenAnswer((_) async => Future.value(expectedPengeluaran));

    final result = await usecase(id);

    expect(result, expectedPengeluaran);
    verify(() => mockRepository.getPengeluaranById(id)).called(1);
  });
}
