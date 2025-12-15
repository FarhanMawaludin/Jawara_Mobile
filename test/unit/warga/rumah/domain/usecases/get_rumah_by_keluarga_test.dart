import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/get_rumah_by_keluarga.dart';
import 'package:mocktail/mocktail.dart';


// ======================================================
// MOCK REPOSITORY
// ======================================================
class MockRumahRepository extends Mock implements RumahRepository {}

void main() {
  late MockRumahRepository mockRepository;
  late GetRumahByKeluarga usecase;

  // SAMPLE DATA
  final rumah1 = Rumah(
    id: 1,
    keluargaId: 12,
    blok: "A",
    nomorRumah: "10",
    alamatLengkap: "Jl. Melati No. 10",
    createdAt: DateTime.now(),
  );

  final rumah2 = Rumah(
    id: 2,
    keluargaId: 12,
    blok: "A",
    nomorRumah: "10",
    alamatLengkap: "Jl. Melati No. 10",
    createdAt: DateTime.now(),
  );

  setUp(() {
    mockRepository = MockRumahRepository();
    usecase = GetRumahByKeluarga(mockRepository);
  });

  test('should return list of Rumah from repository by keluargaId', () async {
    // Arrange
    when(
      () => mockRepository.getRumahByKeluarga(99),
    ).thenAnswer((_) async => [rumah1, rumah2]);

    // Act
    final result = await usecase(99);

    // Assert
    expect(result.length, 2);
    expect(result.first.nomorRumah, '10');

    verify(() => mockRepository.getRumahByKeluarga(99)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
