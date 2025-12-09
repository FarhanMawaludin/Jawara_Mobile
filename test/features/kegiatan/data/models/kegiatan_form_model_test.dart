import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/kegiatan/data/models/kegiatan_form_model.dart';

void main() {
  group('KegiatanFormModel -', () {
    group('toJson', () {
      test('should convert to JSON correctly with all fields', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Kerja Bakti',
          kategori: 'lingkungan',
          tanggalKegiatan: DateTime(2025, 12, 5),
          lokasi: 'Kampung Melayu',
          penanggungJawab: 'Budi Santoso',
          deskripsi: 'Bersih-bersih lingkungan',
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['nama_kegiatan'], 'Kerja Bakti');
        expect(json['kategori_kegiatan'], 'lingkungan'); // ✅ FIXED: kategori → kategori_kegiatan
        expect(json['tanggal_kegiatan'], '2025-12-05T00:00:00.000'); // ✅ FIXED: ISO format
        expect(json['lokasi_kegiatan'], 'Kampung Melayu'); // ✅ FIXED: lokasi → lokasi_kegiatan
        expect(json['penanggung_jawab_kegiatan'], 'Budi Santoso'); // ✅ FIXED: penanggung_jawab → penanggung_jawab_kegiatan
        expect(json['deskripsi_kegiatan'], 'Bersih-bersih lingkungan'); // ✅ FIXED: deskripsi → deskripsi_kegiatan
        
        // ✅ REMOVED: latitude & longitude (tidak ada di model)
      });

      test('should handle null optional fields', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: 'sosial',
          tanggalKegiatan: DateTime(2025, 12, 5),
          lokasi: '', // ✅ FIXED: Gunakan empty string karena default value
          penanggungJawab: '', // ✅ FIXED: Gunakan empty string
          deskripsi: '', // ✅ FIXED: Gunakan empty string
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['lokasi_kegiatan'], ''); // ✅ FIXED: Empty string, bukan null
        expect(json['penanggung_jawab_kegiatan'], ''); // ✅ FIXED
        expect(json['deskripsi_kegiatan'], ''); // ✅ FIXED
      });

      test('should handle null tanggalKegiatan', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: 'sosial',
          tanggalKegiatan: null, // ✅ FIXED: Test null date
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['tanggal_kegiatan'], null);
      });

      test('should format date correctly to ISO8601', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: 'sosial',
          tanggalKegiatan: DateTime(2025, 1, 5, 10, 30, 0), // With time
        );

        // Act
        final json = formModel.toJson();

        // Assert
        // ✅ FIXED: ISO8601 format includes time
        expect(json['tanggal_kegiatan'], startsWith('2025-01-05'));
        expect(json['tanggal_kegiatan'], contains('T'));
      });

      test('should convert kategori to lowercase', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: 'SOSIAL', // ✅ FIXED: Test uppercase
          tanggalKegiatan: DateTime(2025, 12, 5),
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['kategori_kegiatan'], 'sosial'); // ✅ Harus lowercase
      });
    });

    group('fromJson', () {
      test('should parse JSON correctly', () {
        // Arrange
        final json = {
          'nama_kegiatan': 'Kerja Bakti',
          'kategori_kegiatan': 'lingkungan',
          'tanggal_kegiatan': '2025-12-05T00:00:00.000',
          'lokasi_kegiatan': 'Kampung Melayu',
          'penanggung_jawab_kegiatan': 'Budi Santoso',
          'deskripsi_kegiatan': 'Bersih-bersih',
        };

        // Act
        final model = KegiatanFormModel.fromJson(json);

        // Assert
        expect(model.namaKegiatan, 'Kerja Bakti');
        expect(model.kategori, 'lingkungan');
        expect(model.tanggalKegiatan, isA<DateTime>());
        expect(model.lokasi, 'Kampung Melayu');
        expect(model.penanggungJawab, 'Budi Santoso');
        expect(model.deskripsi, 'Bersih-bersih');
      });

      test('should handle null values', () {
        // Arrange
        final json = {
          'nama_kegiatan': null,
          'kategori_kegiatan': null,
          'tanggal_kegiatan': null,
          'lokasi_kegiatan': null,
          'penanggung_jawab_kegiatan': null,
          'deskripsi_kegiatan': null,
        };

        // Act
        final model = KegiatanFormModel.fromJson(json);

        // Assert
        expect(model.namaKegiatan, '');
        expect(model.kategori, '');
        expect(model.tanggalKegiatan, null);
        expect(model.lokasi, '');
        expect(model.penanggungJawab, '');
        expect(model.deskripsi, '');
      });
    });

    group('isEmpty', () {
      test('should return true when all fields are empty', () {
        // Arrange
        final formModel = KegiatanFormModel();

        // Act & Assert
        expect(formModel.isEmpty, true);
      });

      test('should return false when any field is filled', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
        );

        // Act & Assert
        expect(formModel.isEmpty, false);
      });
    });

    group('kategoriDisplay', () {
      test('should return title case kategori', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: 'lingkungan',
        );

        // Act & Assert
        expect(formModel.kategoriDisplay, 'Lingkungan');
      });

      test('should handle uppercase input', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: 'SOSIAL',
        );

        // Act & Assert
        expect(formModel.kategoriDisplay, 'Sosial');
      });

      test('should return empty when kategori is empty', () {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test',
          kategori: '',
        );

        // Act & Assert
        expect(formModel.kategoriDisplay, '');
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        // Arrange
        final original = KegiatanFormModel(
          namaKegiatan: 'Original',
          kategori: 'sosial',
          tanggalKegiatan: DateTime(2025, 12, 5),
          lokasi: 'Original Location',
          penanggungJawab: 'Original PJ',
          deskripsi: 'Original Desc',
        );

        // Act
        final copied = original.copyWith(
          namaKegiatan: 'Updated',
          kategori: 'lingkungan',
        );

        // Assert
        expect(copied.namaKegiatan, 'Updated');
        expect(copied.kategori, 'lingkungan');
        expect(copied.lokasi, 'Original Location'); // Unchanged
        expect(copied.penanggungJawab, 'Original PJ'); // Unchanged
      });

      test('should keep original values when not specified', () {
        // Arrange
        final original = KegiatanFormModel(
          namaKegiatan: 'Original',
          kategori: 'sosial',
        );

        // Act
        final copied = original.copyWith();

        // Assert
        expect(copied.namaKegiatan, 'Original');
        expect(copied.kategori, 'sosial');
      });
    });
  });
}