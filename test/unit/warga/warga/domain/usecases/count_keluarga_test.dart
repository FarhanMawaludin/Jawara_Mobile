import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/count_keluarga.dart';
import 'package:mocktail/mocktail.dart';

// Mock
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late CountKeluarga usecase;

  setUp(() {
    mockRepository = MockWargaRepository();
    usecase = CountKeluarga(mockRepository);
  });

  test("CountKeluarga returns count from repository", () async {
    // Arrange
    when(() => mockRepository.countKeluarga())
        .thenAnswer((_) async => 7);

    // Act
    final result = await usecase();

    // Assert
    expect(result, 7);
    verify(() => mockRepository.countKeluarga()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
