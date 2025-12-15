import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/get_all_rumah.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockRumahRepository extends Mock implements RumahRepository {}

void main() {
  late MockRumahRepository mockRepository;
  late GetAllRumah usecase;

  setUp(() {
    mockRepository = MockRumahRepository();
    usecase = GetAllRumah(mockRepository);
  });

  final rumahList = [
    Rumah(
      id: 1,
      keluargaId: 12,
      blok: "A",
      nomorRumah: "10",
      alamatLengkap: "Jl. Melati No. 10",
      createdAt: DateTime.now(),
    ),
  ];

  test("should return list of Rumah from repository", () async {
    // Arrange
    when(() => mockRepository.getAllRumah())
        .thenAnswer((_) async => rumahList);

    // Act
    final result = await usecase();

    // Assert
    expect(result, rumahList);
    verify(() => mockRepository.getAllRumah()).called(1);
  });
}
