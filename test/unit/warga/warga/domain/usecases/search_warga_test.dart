import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/search_warga.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

// Mock repository
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late SearchWarga usecase;

  setUp(() {
    mockRepository = MockWargaRepository();
    usecase = SearchWarga(mockRepository);
  });

  // Sample data
  final wargaList = [
    Warga(
      id: 1,
      keluargaId: 99,
      nama: "Farhan",
      nik: "123456",
      jenisKelamin: "L",
      tanggalLahir: DateTime(2000, 1, 1),
      roleKeluarga: "Anak",
      createdAt: DateTime.now(),
      userId: "u1",
      alamatRumahId: 10,
      noTelp: "0812",
      tempatLahir: "Bandung",
      agama: "Islam",
      golonganDarah: "O",
      pekerjaan: "Mahasiswa",
      status: "Aktif",
      pendidikan: "S1",
    )
  ];

  test("SearchWarga returns list from repository", () async {
    // Arrange
    when(() => mockRepository.searchWarga("far"))
        .thenAnswer((_) async => wargaList);

    // Act
    final result = await usecase("far");

    // Assert
    expect(result.length, 1);
    expect(result.first.nama, "Farhan");

    verify(() => mockRepository.searchWarga("far")).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
