import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/mutasi.dart';
import 'package:jawaramobile/features/warga/domain/repositories/mutasi_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/mutasi/create_mutasi.dart';
import 'package:mocktail/mocktail.dart';

class MockMutasiRepository extends Mock implements MutasiRepository {}

void main() {
  late MockMutasiRepository mockRepository;
  late CreateMutasi usecase;

  setUp(() {
    mockRepository = MockMutasiRepository();
    usecase = CreateMutasi(mockRepository);
  });

  test('should call repository.createMutasi correctly', () async {
    final mutasi = Mutasi(
      id: 1,
      keluargaId: 12,
      rumahId: 5,
      rumahSekarangId: 6,
      jenisMutasi: 'Masuk',
      alasanMutasi: 'Pindah kerja',
      tanggalMutasi: DateTime.now(),
      createdAt: DateTime.now(),
    );

    when(
      () => mockRepository.createMutasi(mutasi),
    ).thenAnswer((_) async => Future.value());

    await usecase(mutasi);

    verify(() => mockRepository.createMutasi(mutasi)).called(1);
  });
}
