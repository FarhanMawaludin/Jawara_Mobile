import 'package:flutter_test/flutter_test.dart';
import '../../../../../lib/features/broadcast/data/models/broadcast_model.dart';
import '../../../../helpers/mock_data.dart';

void main() {
  group('BroadcastModel -', () {
    group('fromJson', () {
      test('should parse JSON correctly', () {
        // Arrange
        final json = MockData.broadcastJsonResponse['data'];

        // Act
        final model = BroadcastModel.fromJson(json);

        // Assert
        expect(model.id, 1);
        expect(model.judulBroadcast, 'Pengumuman Iuran RT'); // ✅ FIXED: judul → judulBroadcast
        expect(model.isiBroadcast, contains('iuran bulan Desember')); // ✅ FIXED: isi → isiBroadcast
        expect(model.fotoBroadcast, null); // ✅ FIXED: foto → fotoBroadcast
        expect(model.dokumenBroadcast, null); // ✅ FIXED: dokumen → dokumenBroadcast
      });

      test('should handle null foto and dokumen', () {
        // Arrange
        final json = {
          'id': 1,
          'judul_broadcast': 'Test', // ✅ FIXED: judul → judul_broadcast
          'isi_broadcast': 'Content', // ✅ FIXED: isi → isi_broadcast
          'foto_broadcast': null, // ✅ FIXED: foto → foto_broadcast
          'dokumen_broadcast': null, // ✅ FIXED: dokumen → dokumen_broadcast
          'created_at': '2025-12-02T10:00:00.000Z'
        };

        // Act
        final model = BroadcastModel.fromJson(json);

        // Assert
        expect(model.fotoBroadcast, null); // ✅ FIXED
        expect(model.dokumenBroadcast, null); // ✅ FIXED
      });
    });

    group('toJson', () {
      test('should convert to JSON correctly', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test Broadcast', // ✅ FIXED: judul → judulBroadcast
          isiBroadcast: 'Test Content', // ✅ FIXED: isi → isiBroadcast
          fotoBroadcast: null, // ✅ FIXED: foto → fotoBroadcast
          dokumenBroadcast: null, // ✅ FIXED: dokumen → dokumenBroadcast
          createdAt: DateTime.parse('2025-12-02T10:00:00.000Z'),
        );

        // Act
        final json = model.toJson();

        // Assert
        expect(json['id'], 1);
        expect(json['judul_broadcast'], 'Test Broadcast'); // ✅ FIXED
        expect(json['isi_broadcast'], 'Test Content'); // ✅ FIXED
        expect(json['foto_broadcast'], null); // ✅ FIXED
        expect(json['dokumen_broadcast'], null); // ✅ FIXED
      });
    });

    group('hasFoto', () {
      test('should return true when foto is valid', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
          fotoBroadcast: 'foto.jpg',
        );

        // Act & Assert
        expect(model.hasFoto, true);
      });

      test('should return false when foto is null', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
          fotoBroadcast: null,
        );

        // Act & Assert
        expect(model.hasFoto, false);
      });

      test('should return false when foto is empty', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
          fotoBroadcast: '',
        );

        // Act & Assert
        expect(model.hasFoto, false);
      });

      test('should return false when foto is NULL string', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
          fotoBroadcast: 'NULL',
        );

        // Act & Assert
        expect(model.hasFoto, false);
      });
    });

    group('hasDokumen', () {
      test('should return true when dokumen is valid', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
          dokumenBroadcast: 'dokumen.pdf',
        );

        // Act & Assert
        expect(model.hasDokumen, true);
      });

      test('should return false when dokumen is null', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
          dokumenBroadcast: null,
        );

        // Act & Assert
        expect(model.hasDokumen, false);
      });
    });

    group('copyWith', () {
      test('should copy with new values', () {
        // Arrange
        final original = BroadcastModel(
          id: 1,
          judulBroadcast: 'Original',
          isiBroadcast: 'Original Content',
        );

        // Act
        final copied = original.copyWith(
          judulBroadcast: 'Updated',
          isiBroadcast: 'Updated Content',
        );

        // Assert
        expect(copied.id, 1);
        expect(copied.judulBroadcast, 'Updated');
        expect(copied.isiBroadcast, 'Updated Content');
      });

      test('should keep original values when not specified', () {
        // Arrange
        final original = BroadcastModel(
          id: 1,
          judulBroadcast: 'Original',
          isiBroadcast: 'Original Content',
        );

        // Act
        final copied = original.copyWith(
          judulBroadcast: 'Updated',
        );

        // Assert
        expect(copied.isiBroadcast, 'Original Content');
      });
    });

    group('equality', () {
      test('should be equal when ids are same', () {
        // Arrange
        final model1 = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test 1',
          isiBroadcast: 'Content 1',
        );
        final model2 = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test 2',
          isiBroadcast: 'Content 2',
        );

        // Act & Assert
        expect(model1, equals(model2));
      });

      test('should not be equal when ids are different', () {
        // Arrange
        final model1 = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
        );
        final model2 = BroadcastModel(
          id: 2,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
        );

        // Act & Assert
        expect(model1, isNot(equals(model2)));
      });
    });

    group('toString', () {
      test('should return correct string representation', () {
        // Arrange
        final model = BroadcastModel(
          id: 1,
          judulBroadcast: 'Test',
          isiBroadcast: 'Content',
        );

        // Act
        final result = model.toString();

        // Assert
        expect(result, 'BroadcastModel(id: 1, judul: Test, isi: Content)');
      });
    });
  });
}