import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/kegiatan/data/models/kegiatan_statistics_model.dart';

void main() {
  group('KegiatanStatisticsModel', () {
    test('should create instance with valid data', () {
      // Arrange & Act
      final model = KegiatanStatisticsModel(
        totalKegiatan: 10,
        selesai: 5,
        hariIni: 2,
        akanDatang: 3,
      );

      // Assert
      expect(model.totalKegiatan, 10);
      expect(model.selesai, 5);
      expect(model.hariIni, 2);
      expect(model.akanDatang, 3);
    });

    test('should create empty instance with factory constructor', () {
      // Act
      final model = KegiatanStatisticsModel.empty();

      // Assert
      expect(model.totalKegiatan, 0);
      expect(model.selesai, 0);
      expect(model.hariIni, 0);
      expect(model.akanDatang, 0);
    });

    group('copyWith', () {
      test('should copy with new totalKegiatan', () {
        // Arrange
        final original = KegiatanStatisticsModel(
          totalKegiatan: 10,
          selesai: 5,
          hariIni: 2,
          akanDatang: 3,
        );

        // Act
        final copied = original.copyWith(totalKegiatan: 20);

        // Assert
        expect(copied.totalKegiatan, 20);
        expect(copied.selesai, 5);
        expect(copied.hariIni, 2);
        expect(copied.akanDatang, 3);
      });

      test('should copy with new selesai', () {
        // Arrange
        final original = KegiatanStatisticsModel(
          totalKegiatan: 10,
          selesai: 5,
          hariIni: 2,
          akanDatang: 3,
        );

        // Act
        final copied = original.copyWith(selesai: 8);

        // Assert
        expect(copied.totalKegiatan, 10);
        expect(copied.selesai, 8);
        expect(copied.hariIni, 2);
        expect(copied.akanDatang, 3);
      });

      test('should copy with new hariIni', () {
        // Arrange
        final original = KegiatanStatisticsModel(
          totalKegiatan: 10,
          selesai: 5,
          hariIni: 2,
          akanDatang: 3,
        );

        // Act
        final copied = original.copyWith(hariIni: 4);

        // Assert
        expect(copied.totalKegiatan, 10);
        expect(copied.selesai, 5);
        expect(copied.hariIni, 4);
        expect(copied.akanDatang, 3);
      });

      test('should copy with new akanDatang', () {
        // Arrange
        final original = KegiatanStatisticsModel(
          totalKegiatan: 10,
          selesai: 5,
          hariIni: 2,
          akanDatang: 3,
        );

        // Act
        final copied = original.copyWith(akanDatang: 7);

        // Assert
        expect(copied.totalKegiatan, 10);
        expect(copied.selesai, 5);
        expect(copied.hariIni, 2);
        expect(copied.akanDatang, 7);
      });

      test('should copy with multiple new values', () {
        // Arrange
        final original = KegiatanStatisticsModel(
          totalKegiatan: 10,
          selesai: 5,
          hariIni: 2,
          akanDatang: 3,
        );

        // Act
        final copied = original.copyWith(
          totalKegiatan: 15,
          selesai: 8,
          hariIni: 4,
          akanDatang: 3,
        );

        // Assert
        expect(copied.totalKegiatan, 15);
        expect(copied.selesai, 8);
        expect(copied.hariIni, 4);
        expect(copied.akanDatang, 3);
      });

      test('should return same values when copyWith called with null', () {
        // Arrange
        final original = KegiatanStatisticsModel(
          totalKegiatan: 10,
          selesai: 5,
          hariIni: 2,
          akanDatang: 3,
        );

        // Act
        final copied = original.copyWith();

        // Assert
        expect(copied.totalKegiatan, original.totalKegiatan);
        expect(copied.selesai, original.selesai);
        expect(copied.hariIni, original.hariIni);
        expect(copied.akanDatang, original.akanDatang);
      });
    });

    test('should handle zero values', () {
      // Act
      final model = KegiatanStatisticsModel(
        totalKegiatan: 0,
        selesai: 0,
        hariIni: 0,
        akanDatang: 0,
      );

      // Assert
      expect(model.totalKegiatan, 0);
      expect(model.selesai, 0);
      expect(model.hariIni, 0);
      expect(model.akanDatang, 0);
    });

    test('should handle large numbers', () {
      // Act
      final model = KegiatanStatisticsModel(
        totalKegiatan: 999999,
        selesai: 500000,
        hariIni: 250000,
        akanDatang: 249999,
      );

      // Assert
      expect(model.totalKegiatan, 999999);
      expect(model.selesai, 500000);
      expect(model.hariIni, 250000);
      expect(model.akanDatang, 249999);
    });
  });
}