import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/get_all_keluarga.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

// Mock Repository
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late GetAllKeluarga getAllKeluarga;

  setUp(() {
    mockRepository = MockWargaRepository();
    getAllKeluarga = GetAllKeluarga(mockRepository);
  });

  // Sample entity list
  final sampleWargaList = [
    Warga(
      id: 1,
      keluargaId: 10,
      nama: "Farhan",
      nik: "123456",
      jenisKelamin: "L",
      tanggalLahir: DateTime(2000, 1, 1),
      roleKeluarga: "Anak",
      createdAt: DateTime.now(),
      userId: "U123",
      alamatRumahId: 2,
      noTelp: "08123",
      tempatLahir: "Bandung",
      agama: "Islam",
      golonganDarah: "O",
      pekerjaan: "Mahasiswa",
      status: "Aktif",
      pendidikan: "S1",
    )
  ];

  test("should return list of keluarga from repository", () async {
    // Arrange
    when(() => mockRepository.getAllKeluarga())
        .thenAnswer((_) async => sampleWargaList);

    // Act
    final result = await getAllKeluarga();

    // Assert
    expect(result, sampleWargaList);
    expect(result.first.nama, "Farhan");

    verify(() => mockRepository.getAllKeluarga()).called(1);
  });
}
