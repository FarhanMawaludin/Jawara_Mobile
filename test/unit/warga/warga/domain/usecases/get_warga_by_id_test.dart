import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/domain/usecases/warga/get_warga_by_id.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:jawaramobile/features/warga/domain/repositories/warga_repository.dart';

class MockWargaRepository extends Mock implements WargaRepository {}

void main() {
  late MockWargaRepository mockRepo;
  late GetWargaById usecase;

  setUp(() {
    mockRepo = MockWargaRepository();
    usecase = GetWargaById(mockRepo);
  });

  final warga = Warga(
    id: 1,
    keluargaId: 99,
    nama: "Farhan",
    nik: "123456789",
    jenisKelamin: "L",
    tanggalLahir: DateTime(2000),
    roleKeluarga: "Anak",
    createdAt: DateTime.now(),
    userId: "u123",
    alamatRumahId: 10,
    noTelp: "08123",
    tempatLahir: "Bandung",
    agama: "Islam",
    golonganDarah: "O",
    pekerjaan: "Mahasiswa",
    status: "Aktif",
    pendidikan: "S1",
  );

  test("GetWargaById memanggil repository.getWargaById dan mengembalikan entity", () async {
    when(() => mockRepo.getWargaById(1)).thenAnswer((_) async => warga);

    final result = await usecase(1);

    expect(result?.id, 1);
    expect(result?.nama, "Farhan");

    verify(() => mockRepo.getWargaById(1)).called(1);
  });
}
