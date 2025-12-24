import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pengeluaran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pengeluaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pengeluaran/get_all_pengeluaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPengeluaranRepository extends Mock implements PengeluaranRepository {}

void main() {
  late MockPengeluaranRepository mockRepository;
  late GetAllPengeluaranUsecase usecase;

  setUp(() {
    mockRepository = MockPengeluaranRepository();
    usecase = GetAllPengeluaranUsecase(mockRepository);
  });

  test('should call repository.getAllPengeluaran correctly', () async {
    final expectedList = [
      Pengeluaran(
        id: 1,
        createdAt: DateTime.now(),
        namaPengeluaran: 'Pembelian alat kebersihan',
        kategoriPengeluaran: 'Operasional',
        tanggalPengeluaran: DateTime.now(),
        jumlah: 75000.0,
        buktiPengeluaran: 'nota_alat_kebersihan.jpg',
      ),
      Pengeluaran(
        id: 2,
        createdAt: DateTime.now(),
        namaPengeluaran: 'Perbaikan jalan',
        kategoriPengeluaran: 'Perbaikan',
        tanggalPengeluaran: DateTime.now(),
        jumlah: 500000.0,
        buktiPengeluaran: 'nota_perbaikan_jalan.jpg',
      ),
    ];

    when(
      () => mockRepository.getAllPengeluaran(),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase();

    expect(result, expectedList);
    verify(() => mockRepository.getAllPengeluaran()).called(1);
  });
}
