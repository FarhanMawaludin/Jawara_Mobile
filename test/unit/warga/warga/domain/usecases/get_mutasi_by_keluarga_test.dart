import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/mutasi/get_mutasi_by_keluarga.dart';
import 'package:mocktail/mocktail.dart';

class MockMutasiRepository extends Mock implements MutasiRepository {}

void main() {
  late MockMutasiRepository mockRepository;
  late GetMutasiByKeluarga usecase;

  setUp(() {
    mockRepository = MockMutasiRepository();
    usecase = GetMutasiByKeluarga(mockRepository);
  });

  test(
    'should return Mutasi when repository has data for given keluargaId',
    () async {
      final now = DateTime.now();
      final mutasi = Mutasi(
        id: 5,
        keluargaId: 200,
        rumahId: 1,
        rumahSekarangId: 2,
        jenisMutasi: 'Masuk',
        alasanMutasi: 'Reason',
        tanggalMutasi: now,
        createdAt: now,
      );

      when(
        () => mockRepository.getMutasiByKeluarga(200),
      ).thenAnswer((_) async => mutasi);

      final result = await usecase(200);

      expect(result, equals(mutasi));
      verify(() => mockRepository.getMutasiByKeluarga(200)).called(1);
    },
  );

  test(
    'should return null when repository has no mutasi for given keluargaId',
    () async {
      when(
        () => mockRepository.getMutasiByKeluarga(9999),
      ).thenAnswer((_) async => null);

      final result = await usecase(9999);

      expect(result, isNull);
      verify(() => mockRepository.getMutasiByKeluarga(9999)).called(1);
    },
  );
}
