import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/mutasi/get_mutasi_by_id.dart';
import 'package:mocktail/mocktail.dart';

class MockMutasiRepository extends Mock implements MutasiRepository {}

void main() {
  late MockMutasiRepository mockRepository;
  late GetMutasiById usecase;

  setUp(() {
    mockRepository = MockMutasiRepository();
    usecase = GetMutasiById(mockRepository);
  });

  test('should return Mutasi when repository has data for given id', () async {
    final now = DateTime.now();
    final mutasi = Mutasi(
      id: 42,
      keluargaId: 100,
      rumahId: 5,
      rumahSekarangId: 6,
      jenisMutasi: 'Masuk',
      alasanMutasi: 'Test reason',
      tanggalMutasi: now,
      createdAt: now,
    );

    when(
      () => mockRepository.getMutasiById(42),
    ).thenAnswer((_) async => mutasi);

    final result = await usecase(42);

    expect(result, equals(mutasi));
    verify(() => mockRepository.getMutasiById(42)).called(1);
  });

  test(
    'should return null when repository has no mutasi for given id',
    () async {
      when(
        () => mockRepository.getMutasiById(999),
      ).thenAnswer((_) async => null);

      final result = await usecase(999);

      expect(result, isNull);
      verify(() => mockRepository.getMutasiById(999)).called(1);
    },
  );
}
