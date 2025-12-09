import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/delete_rumah.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';

// ======================================================
// MOCK
// ======================================================
class MockRumahRepository extends Mock implements RumahRepository {}

void main() {
  late MockRumahRepository mockRepository;
  late DeleteRumah deleteRumah;

  setUp(() {
    mockRepository = MockRumahRepository();
    deleteRumah = DeleteRumah(mockRepository);
  });

  // ======================================================
  // TEST: DeleteRumah harus memanggil repository.deleteRumah(id)
  // ======================================================
  test("DeleteRumah calls repository.deleteRumah with correct id", () async {
    // arrange
    when(() => mockRepository.deleteRumah(1))
        .thenAnswer((_) async {});

    // act
    await deleteRumah(1);

    // assert
    verify(() => mockRepository.deleteRumah(1)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
