import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pengeluaran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pengeluaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pengeluaran/create_pengeluaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPengeluaranRepository extends Mock implements PengeluaranRepository {}

void main() {
  late MockPengeluaranRepository mockRepository;
  late CreatePengeluaranUsecase usecase;

  setUp(() {
    mockRepository = MockPengeluaranRepository();
    usecase = CreatePengeluaranUsecase(mockRepository);
  });

  test('should call repository.createPengeluaran correctly', () async {
    final pengeluaran = Pengeluaran(
      id: 1,
      createdAt: DateTime.now(),
      namaPengeluaran: 'Pembelian alat kebersihan',
      kategoriPengeluaran: 'Operasional',
      tanggalPengeluaran: DateTime.now(),
      jumlah: 75000.0,
      buktiPengeluaran: 'nota_alat_kebersihan.jpg',
    );

    when(
      () => mockRepository.createPengeluaran(pengeluaran),
    ).thenAnswer((_) async => Future.value());

    await usecase(pengeluaran);

    verify(() => mockRepository.createPengeluaran(pengeluaran)).called(1);
  });
}
