import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/pengeluaran.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/pengeluaran_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/pengeluaran/update_pengeluaran_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockPengeluaranRepository extends Mock implements PengeluaranRepository {}

void main() {
  late MockPengeluaranRepository mockRepository;
  late UpdatePengeluaranUsecase usecase;

  setUp(() {
    mockRepository = MockPengeluaranRepository();
    usecase = UpdatePengeluaranUsecase(mockRepository);
  });

  test('should call repository.updatePengeluaran correctly', () async {
    final updated = Pengeluaran(
      id: 1,
      createdAt: DateTime.now(),
      namaPengeluaran: 'Pembelian alat kebersihan updated',
      kategoriPengeluaran: 'Operasional',
      tanggalPengeluaran: DateTime.now(),
      jumlah: 100000.0,
      buktiPengeluaran: 'nota_alat_kebersihan_updated.jpg',
    );

    when(
      () => mockRepository.updatePengeluaran(updated),
    ).thenAnswer((_) async => Future.value());

    await usecase(updated);

    verify(() => mockRepository.updatePengeluaran(updated)).called(1);
  });
}
