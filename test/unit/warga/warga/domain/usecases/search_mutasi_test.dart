import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/mutasi/search_mutasi.dart';
import 'package:mocktail/mocktail.dart';

class MockMutasiRepository extends Mock implements MutasiRepository {}

void main() {
  late MockMutasiRepository mockRepository;
  late SearchMutasi usecase;

  setUp(() {
    mockRepository = MockMutasiRepository();
    usecase = SearchMutasi(mockRepository);
  });

  test('should return list of Mutasi matching keyword', () async {
    final now = DateTime.now();
    final list = [
      Mutasi(
        id: 1,
        keluargaId: 10,
        rumahId: 5,
        rumahSekarangId: 6,
        jenisMutasi: 'Masuk',
        alasanMutasi: 'Keyword match A',
        tanggalMutasi: now,
        createdAt: now,
      ),
      Mutasi(
        id: 2,
        keluargaId: 11,
        rumahId: 7,
        rumahSekarangId: 8,
        jenisMutasi: 'Keluar',
        alasanMutasi: 'Keyword match B',
        tanggalMutasi: now,
        createdAt: now,
      ),
    ];

    when(
      () => mockRepository.searchMutasi('keyword'),
    ).thenAnswer((_) async => list);

    final result = await usecase('keyword');

    expect(result, equals(list));
    verify(() => mockRepository.searchMutasi('keyword')).called(1);
  });

  test('should return empty list when no matches', () async {
    when(
      () => mockRepository.searchMutasi('none'),
    ).thenAnswer((_) async => <Mutasi>[]);

    final result = await usecase('none');

    expect(result, isEmpty);
    verify(() => mockRepository.searchMutasi('none')).called(1);
  });
}
