import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/get_warga_by_keluarga.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

// -----------------------------------------------------
// MOCK REPOSITORY
// -----------------------------------------------------
class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepository;
  late GetWargaByKeluarga getWargaByKeluarga;

  setUp(() {
    mockRepository = MockWargaRepository();
    getWargaByKeluarga = GetWargaByKeluarga(mockRepository);
  });

  // -----------------------------------------------------
  // SAMPLE DATA
  // -----------------------------------------------------
  final sampleWarga = Warga(
    id: 1,
    keluargaId: 99,
    nama: "Farhan",
    nik: "123",
    jenisKelamin: "L",
    tanggalLahir: DateTime(2000),
    roleKeluarga: "Anak",
    createdAt: DateTime(2024),
    userId: "u123",
    alamatRumahId: 50,
    noTelp: "08123",
    tempatLahir: "Bandung",
    agama: "Islam",
    golonganDarah: "O",
    pekerjaan: "Mahasiswa",
    status: "Aktif",
    pendidikan: "S1",
  );

  // -----------------------------------------------------
  // TEST
  // -----------------------------------------------------
  test("should return list of warga for given keluargaId", () async {
    when(() => mockRepository.getWargaByKeluargaId(99))
        .thenAnswer((_) async => [sampleWarga]);

    final result = await getWargaByKeluarga(99);

    expect(result.length, 1);
    expect(result.first.nama, "Farhan");

    verify(() => mockRepository.getWargaByKeluargaId(99)).called(1);
  });
}
