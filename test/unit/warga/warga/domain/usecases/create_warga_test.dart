import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/create_warga.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';


// Mock class
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late CreateWarga usecase;

  setUp(() {
    mockRepository = MockWargaRepository();
    usecase = CreateWarga(mockRepository);
  });

  test('should call repository.createWarga with correct Warga object', () async {
    // Arrange
    final warga = Warga(
      id: 1,
      keluargaId: 20,
      nama: "Budi Hartono",
      nik: "3512341234123456",
      jenisKelamin: "Laki-Laki",
      tanggalLahir: DateTime.parse("2000-01-01"),
      roleKeluarga: "anak",
      createdAt: DateTime.parse("2025-11-25T10:00:00Z"),
      userId: "uuid-12345",
      alamatRumahId: 15,
      noTelp: "08123456789",
      tempatLahir: "Malang",
      agama: "Islam",
      golonganDarah: "O",
      pekerjaan: "Mahasiswa",
      pendidikan: "SMA",
      status: "belum menikah",
      keluarga: {"nama_keluarga": "Keluarga Hartono"},
      rumah: {"blok": "A", "nomor_rumah": "12"},
    );

    when(() => mockRepository.createWarga(warga))
        .thenAnswer((_) async => Future.value());

    // Act
    await usecase(warga);

    // Assert
    verify(() => mockRepository.createWarga(warga)).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}

