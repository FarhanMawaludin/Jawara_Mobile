import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/mutasi/get_all_mutasi.dart';
import 'package:mocktail/mocktail.dart';

class MockMutasiRepository extends Mock implements MutasiRepository {}

void main() {
  late MockMutasiRepository mockRepository;
  late GetAllMutasi usecase;

  setUp(() {
    mockRepository = MockMutasiRepository();
    usecase = GetAllMutasi(mockRepository);
  });

  test('should return list of Mutasi from repository', () async {
    final now = DateTime.now();
    final list = [
      Mutasi(
        id: 1,
        keluargaId: 10,
        rumahId: 5,
        rumahSekarangId: 6,
        jenisMutasi: 'Masuk',
        alasanMutasi: 'Reason A',
        tanggalMutasi: now,
        createdAt: now,
      ),
      Mutasi(
        id: 2,
        keluargaId: 11,
        rumahId: 7,
        rumahSekarangId: 8,
        jenisMutasi: 'Keluar',
        alasanMutasi: 'Reason B',
        tanggalMutasi: now,
        createdAt: now,
      ),
    ];

    when(() => mockRepository.getAllMutasi()).thenAnswer((_) async => list);

    final result = await usecase();

    expect(result, equals(list));
    verify(() => mockRepository.getAllMutasi()).called(1);
  });
}
