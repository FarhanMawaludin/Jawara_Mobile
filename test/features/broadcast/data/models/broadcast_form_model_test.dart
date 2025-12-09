import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/features/broadcast/data/models/broadcast_form_model.dart';

void main() {
  group('BroadcastFormModel -', () {
    group('toJson', () {
      test('should convert to JSON correctly with all fields', () {
        // Arrange
        final formModel = BroadcastFormModel(
          judul: 'Pengumuman',
          isi: 'Isi pengumuman',
          fotoPath: null,
          dokumenPath: null,
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['judul_broadcast'], 'Pengumuman'); // ✅ FIXED: judul → judul_broadcast
        expect(json['isi_broadcast'], 'Isi pengumuman'); // ✅ FIXED: isi → isi_broadcast
        expect(json['foto_broadcast'], null); // ✅ FIXED: foto → foto_broadcast
        expect(json['dokumen_broadcast'], null); // ✅ FIXED: dokumen → dokumen_broadcast
      });

      test('should handle null foto and dokumen paths', () {
        // Arrange
        final formModel = BroadcastFormModel(
          judul: 'Test',
          isi: 'Content',
          fotoPath: null,
          dokumenPath: null,
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['foto_broadcast'], null); // ✅ FIXED
        expect(json['dokumen_broadcast'], null); // ✅ FIXED
      });

      test('should include foto and dokumen when provided', () {
        // Arrange
        final formModel = BroadcastFormModel(
          judul: 'Test',
          isi: 'Content',
          fotoPath: '/path/to/foto.jpg',
          dokumenPath: '/path/to/dokumen.pdf',
        );

        // Act
        final json = formModel.toJson();

        // Assert
        expect(json['foto_broadcast'], '/path/to/foto.jpg');
        expect(json['dokumen_broadcast'], '/path/to/dokumen.pdf');
      });
    });

    group('fromJson', () {
      test('should parse JSON correctly', () {
        // Arrange
        final json = {
          'judul_broadcast': 'Test Judul',
          'isi_broadcast': 'Test Isi',
          'foto_broadcast': '/path/foto.jpg',
          'dokumen_broadcast': '/path/dokumen.pdf',
        };

        // Act
        final model = BroadcastFormModel.fromJson(json);

        // Assert
        expect(model.judul, 'Test Judul');
        expect(model.isi, 'Test Isi');
        expect(model.fotoPath, '/path/foto.jpg');
        expect(model.dokumenPath, '/path/dokumen.pdf');
      });

      test('should handle null values', () {
        // Arrange
        final json = {
          'judul_broadcast': null,
          'isi_broadcast': null,
          'foto_broadcast': null,
          'dokumen_broadcast': null,
        };

        // Act
        final model = BroadcastFormModel.fromJson(json);

        // Assert
        expect(model.judul, '');
        expect(model.isi, '');
        expect(model.fotoPath, null);
        expect(model.dokumenPath, null);
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        // Arrange
        final original = BroadcastFormModel(
          judul: 'Original',
          isi: 'Original Content',
        );

        // Act
        final copied = original.copyWith(
          judul: 'Updated',
          isi: 'Updated Content',
        );

        // Assert
        expect(copied.judul, 'Updated');
        expect(copied.isi, 'Updated Content');
      });
    });

    group('validation', () {
      test('isValid should return true when judul and isi are not empty', () {
        final model = BroadcastFormModel(
          judul: 'Test',
          isi: 'Content',
        );

        expect(model.isValid, true);
      });

      test('isValid should return false when judul is empty', () {
        final model = BroadcastFormModel(
          judul: '',
          isi: 'Content',
        );

        expect(model.isValid, false);
      });

      test('isEmpty should return true when all fields are empty', () {
        final model = BroadcastFormModel();

        expect(model.isEmpty, true);
      });
    });
  });
}