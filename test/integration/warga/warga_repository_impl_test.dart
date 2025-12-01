import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/data/datasources/warga_remote_datasource.dart';
import 'package:jawaramobile/features/warga/data/models/warga_model.dart';
import 'package:jawaramobile/features/warga/data/repositories/warga_repository_impl.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:mocktail/mocktail.dart';


// ======================================================
// MOCKS
// ======================================================
class MockWargaRemoteDataSource extends Mock implements WargaRemoteDataSource {}

// ======================================================
// FAKE UNTUK WargaModel → wajib untuk any()
// ======================================================
class FakeWargaModel extends Fake implements WargaModel {}

void main() {
  late MockWargaRemoteDataSource mockRemote;
  late WargaRepositoryImpl repository;

  // ==================================================
  // REGISTER FALLBACK VALUE (wajib untuk any<WargaModel>())
  // ==================================================
  setUpAll(() {
    registerFallbackValue(FakeWargaModel());
  });

  setUp(() {
    mockRemote = MockWargaRemoteDataSource();
    repository = WargaRepositoryImpl(mockRemote);
  });

  // ==================================================
  // SAMPLE DATA
  // ==================================================
  final wargaEntity = Warga(
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

  final wargaModel = WargaModel(
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

  // ==================================================
  // GET ALL WARGA
  // ==================================================
  test("getAllWarga returns list from datasource", () async {
    when(() => mockRemote.getAllWarga())
        .thenAnswer((_) async => [wargaModel]);

    final result = await repository.getAllWarga();

    expect(result.length, 1);
    expect(result.first.nama, "Farhan");

    verify(() => mockRemote.getAllWarga()).called(1);
  });

  // ==================================================
  // GET WARGA BY ID
  // ==================================================
  test("getWargaById returns data from datasource", () async {
    when(() => mockRemote.getWargaById(1))
        .thenAnswer((_) async => wargaModel);

    final result = await repository.getWargaById(1);

    expect(result?.id, 1);
    verify(() => mockRemote.getWargaById(1)).called(1);
  });

  // ==================================================
  // CREATE WARGA
  // ==================================================
  test("createWarga calls datasource.createWarga with WargaModel", () async {
    when(() => mockRemote.createWarga(any()))
        .thenAnswer((_) async {});

    await repository.createWarga(wargaEntity);

    verify(() => mockRemote.createWarga(any()))
        .called(1);
  });

  // ==================================================
  // UPDATE WARGA
  // ==================================================
  test("updateWarga calls datasource.updateWarga with WargaModel", () async {
    when(() => mockRemote.updateWarga(any()))
        .thenAnswer((_) async {});

    await repository.updateWarga(wargaEntity);

    verify(() => mockRemote.updateWarga(any()))
        .called(1);
  });

  // ==================================================
  // DELETE WARGA
  // ==================================================
  test("deleteWarga calls datasource.deleteWarga", () async {
    when(() => mockRemote.deleteWarga(1))
        .thenAnswer((_) async {});

    await repository.deleteWarga(1);

    verify(() => mockRemote.deleteWarga(1)).called(1);
  });

  // ==================================================
  // COUNT WARGA
  // ==================================================
  test("countWarga returns integer from datasource", () async {
    when(() => mockRemote.countWarga()).thenAnswer((_) async => 10);

    final count = await repository.countWarga();

    expect(count, 10);
    verify(() => mockRemote.countWarga()).called(1);
  });
}
