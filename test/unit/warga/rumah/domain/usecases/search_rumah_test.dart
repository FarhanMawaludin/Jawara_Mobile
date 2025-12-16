import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/entities/rumah.dart';
import 'package:jawaramobile/features/warga/domain/repositories/rumah_repository.dart';
import 'package:jawaramobile/features/warga/domain/usecases/rumah/search_rumah.dart';
import 'package:mocktail/mocktail.dart';

// Mock Repository
class MockRumahRepository extends Mock implements RumahRepository {}

void main() {
  late MockRumahRepository mockRepository;
  late SearchRumah usecase;

  setUp(() {
    mockRepository = MockRumahRepository();
    usecase = SearchRumah(mockRepository);
  });

  // Sample data
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

  test("SearchRumah returns list of Rumah from repository", () async {
    when(() => mockRepository.searchRumah("mel"))
        .thenAnswer((_) async => rumahList);

    final result = await usecase("mel");

    expect(result.length, 1);
    expect(result.first.alamatLengkap, "Jl. Melati No. 10");

    verify(() => mockRepository.searchRumah("mel")).called(1);
  });
}
