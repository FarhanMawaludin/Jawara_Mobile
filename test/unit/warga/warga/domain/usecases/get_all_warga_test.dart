import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/get_all_warga.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

// ======================================================
// MOCK REPOSITORY
// ======================================================
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late GetAllWarga usecase;

  setUp(() {
    mockRepository = MockWargaRepository();
    usecase = GetAllWarga(mockRepository);
  });

  // SAMPLE DATA
  final tWarga = Warga(
    id: 1,
    keluargaId: 10,
    nama: "Farhan",
    nik: "123",
    jenisKelamin: "L",
    tanggalLahir: DateTime(2000, 1, 1),
    roleKeluarga: "Anak",
    createdAt: DateTime.now(),
    userId: "user123",
    alamatRumahId: 10,
    noTelp: "08123",
    tempatLahir: "Bandung",
    agama: "Islam",
    golonganDarah: "O",
    pekerjaan: "Mahasiswa",
    status: "Aktif",
    pendidikan: "S1",
  );

  test("should return list of Warga from repository", () async {
    // Arrange
    when(() => mockRepository.getAllWarga())
        .thenAnswer((_) async => [tWarga]);

    // Act
    final result = await usecase();

    // Assert
    expect(result, isA<List<Warga>>());
    expect(result.length, 1);
    expect(result.first.nama, "Farhan");

    verify(() => mockRepository.getAllWarga()).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
