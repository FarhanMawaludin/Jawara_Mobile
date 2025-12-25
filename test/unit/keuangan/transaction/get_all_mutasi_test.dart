import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/keuangan/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/keuangan/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/keuangan/domain/usecase/transaction/get_all_mutasi.dart';
import 'package:mocktail/mocktail.dart';

class MockMutasiRepository extends Mock implements MutasiRepository {}

void main() {
  late MockMutasiRepository mockRepository;
  late GetAllMutasi usecase;

  setUp(() {
    mockRepository = MockMutasiRepository();
    usecase = GetAllMutasi(mockRepository);
  });

  test('should call repository.getAllMutasi correctly', () async {
    final expectedList = [
      Mutasi(
        id: 1,
        jenis: MutasiType.pemasukan,
        nama: 'Iuran Bulanan',
        kategori: 'Iuran',
        tanggal: DateTime.now(),
        jumlah: 100000.0,
        bukti: null,
      ),
      Mutasi(
        id: 2,
        jenis: MutasiType.pengeluaran,
        nama: 'Pembelian alat kebersihan',
        kategori: 'Operasional',
        tanggal: DateTime.now(),
        jumlah: 50000.0,
        bukti: 'nota_alat.jpg',
      ),
    ];

    when(
      () => mockRepository.getAllMutasi(),
    ).thenAnswer((_) async => Future.value(expectedList));

    final result = await usecase();

    expect(result, expectedList);
    verify(() => mockRepository.getAllMutasi()).called(1);
  });

  test('should return empty list when no mutasi exists', () async {
    when(
      () => mockRepository.getAllMutasi(),
    ).thenAnswer((_) async => Future.value([]));

    final result = await usecase();

    expect(result, isEmpty);
    verify(() => mockRepository.getAllMutasi()).called(1);
  });
}
