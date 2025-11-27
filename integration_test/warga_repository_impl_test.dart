import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/warga/data/datasources/warga_remote_datasource.dart';
import 'package:jawaramobile/features/warga/data/models/warga_model.dart';
import 'package:jawaramobile/features/warga/data/repositories/warga_repository_impl.dart';
import 'package:jawaramobile/features/warga/domain/entities/warga.dart';
import 'package:mocktail/mocktail.dart';

class MockWargaRemoteDataSource extends Mock
    implements WargaRemoteDataSource {}

/// Tambahkan Fake
class FakeWargaModel extends Fake implements WargaModel {}

void main() {
  late MockWargaRemoteDataSource mockDataSource;
  late WargaRepositoryImpl repository;

  /// WAJIB daftar fallback value
  setUpAll(() {
    registerFallbackValue(FakeWargaModel());
  });

  setUp(() {
    mockDataSource = MockWargaRemoteDataSource();
    repository = WargaRepositoryImpl(mockDataSource);
  });

  final wargaModel = WargaModel(
    id: 1,
    nama: "Budi",
    keluargaId: 2,
    nik: "1237777777777777",
    jenisKelamin: "L",
    tanggalLahir: DateTime.parse("2001-01-01"),
    roleKeluarga: "kepala_keluarga",
    createdAt: DateTime.parse("2001-01-01"),
    userId: "6",
    alamatRumahId: 10,
    noTelp: "08123",
    tempatLahir: "Bandung",
    agama: "islam",
    golonganDarah: "O",
    pekerjaan: "Pelajar",
    status: "aktif",
    pendidikan: "SMA",
  );

  final wargaEntity = Warga(
    id: 1,
    nama: "Budi",
    keluargaId: 2,
    nik: "1237777777777777",
    jenisKelamin: "L",
    tanggalLahir: DateTime.parse("2001-01-01"),
    roleKeluarga: "kepala_keluarga",
    createdAt: DateTime.parse("2001-01-01"),
    userId: "6",
    alamatRumahId: 10,
    noTelp: "08123",
    tempatLahir: "Bandung",
    agama: "islam",
    golonganDarah: "O",
    pekerjaan: "Pelajar",
    status: "aktif",
    pendidikan: "SMA",
  );

  group('WargaRepositoryImpl Integration Test', () {
    test('getAllWarga() returns list dari datasource', () async {
      when(() => mockDataSource.getAllWarga())
          .thenAnswer((_) async => [wargaModel]);

      final result = await repository.getAllWarga();

      expect(result.length, 1);
      expect(result.first.nama, equals("Budi"));
      verify(() => mockDataSource.getAllWarga()).called(1);
    });

    test('getWargaById() memanggil datasource dengan benar', () async {
      when(() => mockDataSource.getWargaById(1))
          .thenAnswer((_) async => wargaModel);

      final result = await repository.getWargaById(1);

      expect(result?.nama, "Budi");
      verify(() => mockDataSource.getWargaById(1)).called(1);
    });

    test('searchWarga() memanggil datasource', () async {
      when(() => mockDataSource.searchWarga("Bu"))
          .thenAnswer((_) async => [wargaModel]);

      final result = await repository.searchWarga("Bu");

      expect(result.first.nama, "Budi");
      verify(() => mockDataSource.searchWarga("Bu")).called(1);
    });

    test('createWarga() memanggil datasource dengan model', () async {
      when(() => mockDataSource.createWarga(any()))
          .thenAnswer((_) async => null);

      await repository.createWarga(wargaEntity);

      verify(() => mockDataSource.createWarga(any())).called(1);
    });

    test('updateWarga() memanggil datasource', () async {
      when(() => mockDataSource.updateWarga(any()))
          .thenAnswer((_) async => null);

      await repository.updateWarga(wargaEntity);

      verify(() => mockDataSource.updateWarga(any())).called(1);
    });

    test('deleteWarga() memanggil datasource dengan id benar', () async {
      when(() => mockDataSource.deleteWarga(1))
          .thenAnswer((_) async => null);

      await repository.deleteWarga(1);

      verify(() => mockDataSource.deleteWarga(1)).called(1);
    });
  });
}
