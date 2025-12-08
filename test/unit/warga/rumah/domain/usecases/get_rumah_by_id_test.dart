import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/get_rumah_by_id.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockRumahRepository extends Mock implements RumahRepository {}

void main() {
  late MockRumahRepository mockRepository;
  late GetRumahById usecase;

  setUp(() {
    mockRepository = MockRumahRepository();
    usecase = GetRumahById(mockRepository);
  });

  // Sample entity
  final rumah = Rumah(
    id: 1,
    keluargaId: 12,
    blok: "A",
    nomorRumah: "10",
    alamatLengkap: "Jl. Melati No. 10",
    createdAt: DateTime.now(),
  );

  test("GetRumahById returns data from repository", () async {
    // Arrange
    when(() => mockRepository.getRumahById(1)).thenAnswer((_) async => rumah);

    // Act
    final result = await usecase(1);

    // Assert
    expect(result, isNotNull);
    expect(result?.id, 1);
    verify(() => mockRepository.getRumahById(1)).called(1);
  });
}
