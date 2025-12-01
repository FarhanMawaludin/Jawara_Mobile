import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:jawaramobile/features/register/domain/usecases/create_keluarga_and_warga.dart';
import 'package:jawaramobile/features/register/domain/repositories/register_repository.dart';

class MockRegisterRepository extends Mock implements RegisterRepository {}

void main() {
  late MockRegisterRepository mockRepository;
  late CreateKeluargaAndWarga usecase;

  setUp(() {
    mockRepository = MockRegisterRepository();
    usecase = CreateKeluargaAndWarga(mockRepository);
  });

  group('CreateKeluargaAndWarga Usecase', () {
    const userId = "user-123";
    const nama = "Farhan Mawaludin";
    const nik = "1234567890123456";
    const jenisKelamin = "L";
    final tanggalLahir = DateTime(2002, 10, 10);
    const roleKeluarga = "kepala-keluarga";

    test('should return keluargaId when repository succeeds', () async {
      // Arrange
      when(() => mockRepository.createKeluargaAndWarga(
            userId: userId,
            nama: nama,
            nik: nik,
            jenisKelamin: jenisKelamin,
            tanggalLahir: tanggalLahir,
            roleKeluarga: roleKeluarga,
          )).thenAnswer((_) async => 777);

      // Act
      final result = await usecase(
        userId: userId,
        nama: nama,
        nik: nik,
        jenisKelamin: jenisKelamin,
        tanggalLahir: tanggalLahir,
        roleKeluarga: roleKeluarga,
      );

      // Assert
      expect(result, 777);
      verify(() => mockRepository.createKeluargaAndWarga(
            userId: userId,
            nama: nama,
            nik: nik,
            jenisKelamin: jenisKelamin,
            tanggalLahir: tanggalLahir,
            roleKeluarga: roleKeluarga,
          )).called(1);
    });

    test('should throw exception when repository throws error', () async {
      // Arrange
      when(() => mockRepository.createKeluargaAndWarga(
            userId: userId,
            nama: nama,
            nik: nik,
            jenisKelamin: jenisKelamin,
            tanggalLahir: tanggalLahir,
            roleKeluarga: roleKeluarga,
          )).thenThrow(Exception("Failed to create keluarga and warga"));

      // Act
      final call = usecase(
        userId: userId,
        nama: nama,
        nik: nik,
        jenisKelamin: jenisKelamin,
        tanggalLahir: tanggalLahir,
        roleKeluarga: roleKeluarga,
      );

      // Assert
      expect(() => call, throwsA(isA<Exception>()));
      verify(() => mockRepository.createKeluargaAndWarga(
            userId: userId,
            nama: nama,
            nik: nik,
            jenisKelamin: jenisKelamin,
            tanggalLahir: tanggalLahir,
            roleKeluarga: roleKeluarga,
          )).called(1);
    });
  });
}
