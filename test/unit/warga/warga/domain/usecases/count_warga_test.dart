import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/count_warga.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

// Mock repository
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepo;
  late CountWarga usecase;

  setUp(() {
    mockRepo = MockWargaRepository();
    usecase = CountWarga(mockRepo);
  });

  test("CountWarga returns integer from repository", () async {
    // Arrange
    when(() => mockRepo.countWarga()).thenAnswer((_) async => 15);

    // Act
    final result = await usecase();

    // Assert
    expect(result, 15);
    verify(() => mockRepo.countWarga()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
