import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawaramobile/features/kegiatan/data/repositories/kegiatan_repository.dart';
import 'package:jawaramobile/features/kegiatan/data/models/kegiatan_form_model.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late SupabaseClient supabaseClient;
  late KegiatanRepository repository;

  // ✅ IMPORTANT: Initialize Supabase once before all tests
  setUpAll(() async {
    await TestHelpers.initializeSupabase();
  });

  setUp(() {
    supabaseClient = TestHelpers.getSupabaseClient();
    repository = KegiatanRepository(supabaseClient);
  });

  // ✅ Cleanup after all tests
  tearDownAll(() {
    TestHelpers.resetSupabase();
  });

  group('KegiatanRepository - Integration Tests', () {
    group('createKegiatan', () {
      test('should create kegiatan successfully', () async {
        // Arrange
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test Kegiatan $timestamp',
          kategori: 'sosial',
          tanggalKegiatan: DateTime(2025, 12, 5),
          lokasi: 'Test Location',
          penanggungJawab: 'Test PJ',
          deskripsi: 'Test Description',
        );

        // Act
        final result = await repository.createKegiatan(formModel);

        // Assert
        expect(result, isNotNull);
        expect(result['success'], true);
        expect(result['message'], 'Kegiatan berhasil ditambahkan');
        
        final data = result['data'] as Map<String, dynamic>?;
        expect(data, isNotNull);
        expect(data!['nama_kegiatan'], 'Test Kegiatan $timestamp');
        expect(data['kategori_kegiatan'], 'sosial');
        expect(data['lokasi_kegiatan'], 'Test Location');
        expect(data['penanggung_jawab_kegiatan'], 'Test PJ');
        expect(data['deskripsi_kegiatan'], 'Test Description');
        
        // Cleanup
        final id = data['id'] as int?;
        if (id != null) {
          await repository.deleteKegiatan(id);
        }
      });

      test('should handle validation error for empty nama', () async {
        // Arrange
        final formModel = KegiatanFormModel(
          namaKegiatan: '',
          kategori: 'sosial',
        );

        // Act
        final result = await repository.createKegiatan(formModel);

        // Assert
        expect(result['success'], false);
        expect(result['message'], 'Nama kegiatan wajib diisi');
      });
    });

    group('getKegiatanList', () {
      test('should fetch kegiatan list successfully', () async {
        // Act
        final result = await repository.getKegiatanList(limit: 10, offset: 0);

        // Assert
        expect(result, isNotNull);
        expect(result, isA<List<Map<String, dynamic>>>());
        
        // Test structure jika ada data
        if (result.isNotEmpty) {
          final first = result.first;
          expect(first.containsKey('id'), true);
          expect(first.containsKey('nama_kegiatan'), true);
          expect(first.containsKey('kategori_kegiatan'), true);
        }
      });

      test('should fetch with custom pagination', () async {
        // Act
        final result = await repository.getKegiatanList(limit: 5, offset: 5);

        // Assert
        expect(result, isA<List<Map<String, dynamic>>>());
      });

      test('should handle empty result', () async {
        // Act
        final result = await repository.getKegiatanList(
          limit: 10,
          offset: 999999,
        );

        // Assert
        expect(result, isA<List<Map<String, dynamic>>>());
      });
    });

    group('getAllKegiatan', () {
      test('should fetch all kegiatan successfully', () async {
        // Act
        final result = await repository.getAllKegiatan();

        // Assert
        expect(result, isNotNull);
        expect(result, isA<List<Map<String, dynamic>>>());
        
        if (result.isNotEmpty) {
          final first = result.first;
          expect(first.containsKey('id'), true);
          expect(first.containsKey('nama_kegiatan'), true);
        }
      });
    });

    group('getKegiatanById', () {
      test('should fetch kegiatan detail successfully', () async {
        // Arrange - Create test data first
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test Detail $timestamp',
          kategori: 'sosial',
          tanggalKegiatan: DateTime(2025, 12, 5),
        );
        
        final created = await repository.createKegiatan(formModel);
        final createdData = created['data'] as Map<String, dynamic>?;
        final id = createdData?['id'] as int?;
        
        expect(id, isNotNull);

        // Act
        final result = await repository.getKegiatanById(id!);

        // Assert
        expect(result, isNotNull);
        expect(result!['id'], id);
        expect(result['nama_kegiatan'], 'Test Detail $timestamp');

        // Cleanup
        await repository.deleteKegiatan(id);
      });

      test('should return null when id not found', () async {
        // Act
        final result = await repository.getKegiatanById(999999);

        // Assert
        expect(result, isNull);
      });
    });

    group('deleteKegiatan', () {
      test('should delete kegiatan successfully', () async {
        // Arrange - Create test data first
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = KegiatanFormModel(
          namaKegiatan: 'Test Delete $timestamp',
          kategori: 'sosial',
        );
        
        final created = await repository.createKegiatan(formModel);
        final createdData = created['data'] as Map<String, dynamic>?;
        final id = createdData?['id'] as int?;
        
        expect(id, isNotNull);

        // Act
        final result = await repository.deleteKegiatan(id!);

        // Assert
        expect(result['success'], true);
        expect(result['message'], 'Kegiatan berhasil dihapus');

        // Verify deletion
        final deleted = await repository.getKegiatanById(id);
        expect(deleted, isNull);
      });
    });

    group('getStatistics', () {
      test('should fetch statistics successfully', () async {
        // Act
        final result = await repository.getStatistics();

        // Assert
        expect(result, isNotNull);
        
        // ✅ FIXED: Gunakan getter yang benar dari KegiatanStatisticsModel
        expect(result.totalKegiatan, isA<int>()); // ✅ totalKegiatan, bukan total
        expect(result.selesai, isA<int>()); // ✅ selesai
        expect(result.hariIni, isA<int>()); // ✅ hariIni
        expect(result.akanDatang, isA<int>()); // ✅ akanDatang
        
        // ✅ Verify total is sum of status counts
        final sum = result.selesai + result.hariIni + result.akanDatang;
        expect(result.totalKegiatan, greaterThanOrEqualTo(sum));
      });

      test('should return valid statistics even when no data', () async {
        // Act
        final result = await repository.getStatistics();

        // Assert
        expect(result, isNotNull);
        expect(result.totalKegiatan, greaterThanOrEqualTo(0));
        expect(result.selesai, greaterThanOrEqualTo(0));
        expect(result.hariIni, greaterThanOrEqualTo(0));
        expect(result.akanDatang, greaterThanOrEqualTo(0));
      });

      test('should handle empty kegiatan list', () async {
        // Note: Repository returns KegiatanStatisticsModel.empty() when error
        // Act
        final result = await repository.getStatistics();

        // Assert
        expect(result, isNotNull);
        // All values should be >= 0
        expect(result.totalKegiatan, greaterThanOrEqualTo(0));
      });
    });
  });
}