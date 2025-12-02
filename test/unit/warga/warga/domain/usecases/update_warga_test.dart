import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/update_warga.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

// Mock
class MockWargaRepository extends Mock implements WargaRepository {}

// Fake Warga untuk any()
class FakeWarga extends Fake implements Warga {}

void main() {
  late MockWargaRepository mockRepository;
  late UpdateWarga usecase;

  setUpAll(() {
    registerFallbackValue(FakeWarga());
  });

  setUp(() {
    mockRepository = MockWargaRepository();
    usecase = UpdateWarga(mockRepository);
  });

  final warga = Warga(
    id: 1,
    keluargaId: 99,
    nama: "Farhan",
    nik: "123456789",
    jenisKelamin: "L",
    tanggalLahir: DateTime(2000, 1, 1),
    roleKeluarga: "Anak",
    createdAt: DateTime.now(),
    userId: "u123",
    alamatRumahId: 10,
    noTelp: "08123456789",
    tempatLahir: "Bandung",
    agama: "Islam",
    golonganDarah: "O",
    pekerjaan: "Mahasiswa",
    status: "Aktif",
    pendidikan: "S1",
  );

  test("should call repository.updateWarga with correct warga", () async {
    // Arrange
    when(() => mockRepository.updateWarga(any()))
        .thenAnswer((_) async {});

    // Act
    await usecase(warga);

    // Assert
    verify(() => mockRepository.updateWarga(warga)).called(1);
  });
}
