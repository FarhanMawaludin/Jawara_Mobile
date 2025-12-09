import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/kegiatan/data/models/kegiatan_model.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('KegiatanModel -', () {
    group('fromJson', () {
      test('should parse JSON correctly', () {
        // Arrange
        final json = MockData.kegiatanJsonResponse['data'];

        // Act
        final model = KegiatanModel.fromJson(json);

        // Assert
        expect(model.id, 1);
        expect(model.namaKegiatan, 'Kerja Bakti Lingkungan');
        expect(model.kategoriKegiatan, KategoriKegiatan.sosial);
        expect(model.tanggalKegiatan, isA<DateTime>()); // ✅ FIXED: DateTime, bukan String
        expect(model.lokasiKegiatan, 'Kampung Melayu'); // ✅ FIXED: lokasi → lokasiKegiatan
        expect(model.penanggungJawabKegiatan, 'Budi Santoso'); // ✅ FIXED: penanggungJawab → penanggungJawabKegiatan
        expect(model.deskripsiKegiatan, 'Kegiatan bersih-bersih lingkungan'); // ✅ FIXED: deskripsi → deskripsiKegiatan
      });

      test('should handle null optional fields', () {
        // Arrange
        final json = {
          'id': 1,
          'nama_kegiatan': 'Test',
          'kategori_kegiatan': 'sosial',
          'tanggal_kegiatan': '2025-12-05T00:00:00.000Z',
          'lokasi_kegiatan': 'Test Location',
          'penanggung_jawab_kegiatan': 'Test PJ',
          'deskripsi_kegiatan': null, // ✅ FIXED: Gunakan null
          'created_at': '2025-12-02T10:00:00.000Z'
        };

        // Act
        final model = KegiatanModel.fromJson(json);

        // Assert
        expect(model.deskripsiKegiatan, null); // ✅ FIXED
      });

      test('should parse unknown kategori as lainnya', () {
        // Arrange
        final json = {
          'id': 1,
          'nama_kegiatan': 'Test',
          'kategori_kegiatan': 'unknown_category',
          'tanggal_kegiatan': '2025-12-05T00:00:00.000Z',
          'created_at': '2025-12-02T10:00:00.000Z'
        };

        // Act
        final model = KegiatanModel.fromJson(json);

        // Assert
        expect(model.kategoriKegiatan, KategoriKegiatan.lainnya);
      });

      test('should handle null kategori as lainnya', () {
        // Arrange
        final json = {
          'id': 1,
          'nama_kegiatan': 'Test',
          'kategori_kegiatan': null,
          'tanggal_kegiatan': '2025-12-05T00:00:00.000Z',
          'created_at': '2025-12-02T10:00:00.000Z'
        };

        // Act
        final model = KegiatanModel.fromJson(json);

        // Assert
        expect(model.kategoriKegiatan, KategoriKegiatan.lainnya);
      });
    });

    group('toJson', () {
      test('should convert to JSON correctly', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test Kegiatan',
          kategoriKegiatan: KategoriKegiatan.sosial, // ✅ FIXED: Gunakan enum
          tanggalKegiatan: DateTime.parse('2025-12-05T00:00:00.000Z'), // ✅ FIXED: DateTime
          lokasiKegiatan: 'Test Location', // ✅ FIXED
          penanggungJawabKegiatan: 'Test PJ', // ✅ FIXED
          deskripsiKegiatan: 'Test Description', // ✅ FIXED
          createdAt: DateTime.parse('2025-12-02T10:00:00.000Z'),
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], 1);
        expect(json['nama_kegiatan'], 'Test Kegiatan');
        expect(json['kategori_kegiatan'], 'sosial'); // ✅ FIXED: enum.name returns lowercase
        expect(json['tanggal_kegiatan'], isA<String>()); // ✅ FIXED: ISO8601 String
        expect(json['lokasi_kegiatan'], 'Test Location'); // ✅ FIXED
        expect(json['penanggung_jawab_kegiatan'], 'Test PJ'); // ✅ FIXED
        expect(json['deskripsi_kegiatan'], 'Test Description'); // ✅ FIXED
      });
    });

    group('status', () {
      test('should return "Selesai" for past date', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime.now().subtract(const Duration(days: 1)),
        );

        // Act & Assert
        expect(model.status, 'Selesai');
      });

      test('should return "Hari Ini" for today', () {
        // Arrange
        final now = DateTime.now();
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime(now.year, now.month, now.day),
        );

        // Act & Assert
        expect(model.status, 'Hari Ini');
      });

      test('should return "Akan Datang" for future date', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime.now().add(const Duration(days: 1)),
        );

        // Act & Assert
        expect(model.status, 'Akan Datang');
      });

      test('should return "Tanggal Belum Ditentukan" when date is null', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: null,
        );

        // Act & Assert
        expect(model.status, 'Tanggal Belum Ditentukan');
      });
    });

    group('isUpcoming', () {
      test('should return true for upcoming event', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime.now().add(const Duration(days: 1)),
        );

        // Act & Assert
        expect(model.isUpcoming, true);
      });

      test('should return true for today event', () {
        // Arrange
        final now = DateTime.now();
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime(now.year, now.month, now.day),
        );

        // Act & Assert
        expect(model.isUpcoming, true);
      });

      test('should return false for past event', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime.now().subtract(const Duration(days: 1)),
        );

        // Act & Assert
        expect(model.isUpcoming, false);
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        // Arrange
        final original = KegiatanModel(
          id: 1,
          namaKegiatan: 'Original',
          kategoriKegiatan: KategoriKegiatan.sosial,
          tanggalKegiatan: DateTime(2025, 12, 5),
        );

        // Act
        final copied = original.copyWith(
          namaKegiatan: 'Updated',
          kategoriKegiatan: KategoriKegiatan.pendidikan,
        );

        // Assert
        expect(copied.id, 1);
        expect(copied.namaKegiatan, 'Updated');
        expect(copied.kategoriKegiatan, KategoriKegiatan.pendidikan);
      });

      test('should keep original values when not specified', () {
        // Arrange
        final original = KegiatanModel(
          id: 1,
          namaKegiatan: 'Original',
          kategoriKegiatan: KategoriKegiatan.sosial,
        );

        // Act
        final copied = original.copyWith();

        // Assert
        expect(copied.namaKegiatan, 'Original');
        expect(copied.kategoriKegiatan, KategoriKegiatan.sosial);
      });
    });

    group('equality', () {
      test('should be equal when ids are same', () {
        // Arrange
        final model1 = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test 1',
          kategoriKegiatan: KategoriKegiatan.sosial,
        );
        final model2 = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test 2',
          kategoriKegiatan: KategoriKegiatan.pendidikan,
        );

        // Act & Assert
        expect(model1, equals(model2));
      });

      test('should not be equal when ids are different', () {
        // Arrange
        final model1 = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
        );
        final model2 = KegiatanModel(
          id: 2,
          namaKegiatan: 'Test',
          kategoriKegiatan: KategoriKegiatan.sosial,
        );

        // Act & Assert
        expect(model1, isNot(equals(model2)));
      });
    });

    group('toString', () {
      test('should return correct string representation', () {
        // Arrange
        final model = KegiatanModel(
          id: 1,
          namaKegiatan: 'Test Kegiatan',
          kategoriKegiatan: KategoriKegiatan.sosial,
        );

        // Act
        final result = model.toString();

        // Assert
        expect(result, 'KegiatanModel(id: 1, nama: Test Kegiatan, kategori: Sosial)');
      });
    });
  });

  group('KategoriKegiatan Enum -', () {
    group('displayName', () {
      test('should return correct display names', () {
        expect(KategoriKegiatan.sosial.displayName, 'Sosial');
        expect(KategoriKegiatan.keagamaan.displayName, 'Keagamaan');
        expect(KategoriKegiatan.olahraga.displayName, 'Olahraga');
        expect(KategoriKegiatan.pendidikan.displayName, 'Pendidikan');
        expect(KategoriKegiatan.kesehatan.displayName, 'Kesehatan');
        expect(KategoriKegiatan.lainnya.displayName, 'Lainnya');
      });
    });

    group('fromString', () {
      test('should parse lowercase strings correctly', () {
        expect(KategoriKegiatan.fromString('sosial'), KategoriKegiatan.sosial);
        expect(KategoriKegiatan.fromString('keagamaan'), KategoriKegiatan.keagamaan);
        expect(KategoriKegiatan.fromString('olahraga'), KategoriKegiatan.olahraga);
        expect(KategoriKegiatan.fromString('pendidikan'), KategoriKegiatan.pendidikan);
        expect(KategoriKegiatan.fromString('kesehatan'), KategoriKegiatan.kesehatan);
      });

      test('should parse uppercase strings correctly', () {
        expect(KategoriKegiatan.fromString('SOSIAL'), KategoriKegiatan.sosial);
        expect(KategoriKegiatan.fromString('KEAGAMAAN'), KategoriKegiatan.keagamaan);
      });

      test('should return lainnya for unknown value', () {
        expect(KategoriKegiatan.fromString('unknown'), KategoriKegiatan.lainnya);
        expect(KategoriKegiatan.fromString('xyz'), KategoriKegiatan.lainnya);
      });

      test('should return lainnya for null value', () {
        expect(KategoriKegiatan.fromString(null), KategoriKegiatan.lainnya);
      });
    });
  });
}