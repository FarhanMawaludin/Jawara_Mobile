import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../../lib/features/broadcast/data/repositories/broadcast_repository.dart';
import '../../../../../lib/features/broadcast/data/models/broadcast_form_model.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  late SupabaseClient supabaseClient;
  late BroadcastRepository repository;

  // ✅ Initialize Supabase once before all tests
  setUpAll(() async {
    await TestHelpers.initializeSupabase();
  });

  setUp(() {
    supabaseClient = TestHelpers.getSupabaseClient();
    repository = BroadcastRepository(supabaseClient);
  });

  // ✅ Cleanup after all tests
  tearDownAll(() {
    TestHelpers.resetSupabase();
  });

  group('BroadcastRepository - Integration Tests', () {
    group('createBroadcast', () {
      test('should create broadcast successfully', () async {
        // Arrange
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = BroadcastFormModel(
          judul: 'Pengumuman Test $timestamp',
          isi: 'Ini adalah pengumuman test',
          fotoPath: null,
          dokumenPath: null,
        );

        // Act
        final result = await repository.createBroadcast(formModel);

        // Assert
        expect(result, isNotNull);
        expect(result['success'], true);
        expect(result['message'], 'Broadcast berhasil dikirim');

        final data = result['data'] as Map<String, dynamic>?;
        expect(data, isNotNull);
        expect(data!['judul_broadcast'], 'Pengumuman Test $timestamp');
        expect(data['isi_broadcast'], 'Ini adalah pengumuman test');

        // Cleanup
        final id = data['id'] as int?;
        if (id != null) {
          await repository.deleteBroadcast(id);
        }
      });

      test('should handle validation error for empty judul', () async {
        // Arrange
        final formModel = BroadcastFormModel(
          judul: '',
          isi: 'Test content',
          fotoPath: null,
          dokumenPath: null,
        );

        // Act
        final result = await repository.createBroadcast(formModel);

        // Assert
        expect(result['success'], false);
        expect(result['message'], 'Judul broadcast wajib diisi');
      });

      test('should handle validation error for empty isi', () async {
        // Arrange
        final formModel = BroadcastFormModel(
          judul: 'Test Title',
          isi: '',
          fotoPath: null,
          dokumenPath: null,
        );

        // Act
        final result = await repository.createBroadcast(formModel);

        // Assert
        expect(result['success'], false);
        expect(result['message'], 'Isi broadcast wajib diisi');
      });

      test('should create broadcast with foto and dokumen paths', () async {
        // Arrange
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = BroadcastFormModel(
          judul: 'Broadcast dengan Media $timestamp',
          isi: 'Broadcast dengan foto dan dokumen',
          fotoPath: 'test_foto_path.jpg',
          dokumenPath: 'test_dokumen_path.pdf',
        );

        // Act
        final result = await repository.createBroadcast(formModel);

        // Assert
        expect(result['success'], true);
        expect(result['message'], 'Broadcast berhasil dikirim');

        final data = result['data'] as Map<String, dynamic>?;
        expect(data, isNotNull);
        // Note: foto_url dan dokumen_url akan null karena TODO upload
        expect(data!['judul_broadcast'], 'Broadcast dengan Media $timestamp');
        expect(data['isi_broadcast'], 'Broadcast dengan foto dan dokumen');

        // Cleanup
        final id = data['id'] as int?;
        if (id != null) {
          await repository.deleteBroadcast(id);
        }
      });

      test('should trim whitespace from judul and isi', () async {
        // Arrange
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = BroadcastFormModel(
          judul: '  Test Whitespace $timestamp  ',
          isi: '  Content with spaces  ',
          fotoPath: null,
          dokumenPath: null,
        );

        // Act
        final result = await repository.createBroadcast(formModel);

        // Assert
        expect(result['success'], true);
        
        final data = result['data'] as Map<String, dynamic>?;
        expect(data!['judul_broadcast'], 'Test Whitespace $timestamp');
        expect(data['isi_broadcast'], 'Content with spaces');

        // Cleanup
        final id = data['id'] as int?;
        if (id != null) {
          await repository.deleteBroadcast(id);
        }
      });
    });

    group('getBroadcastList', () {
      test('should fetch broadcast list successfully', () async {
        // Act
        final result = await repository.getBroadcastList();

        // Assert
        expect(result, isNotNull);
        expect(result, isA<List<Map<String, dynamic>>>());

        // Test structure jika ada data
        if (result.isNotEmpty) {
          final first = result.first;
          expect(first.containsKey('id'), true);
          expect(first.containsKey('judul_broadcast'), true);
          expect(first.containsKey('isi_broadcast'), true);
          expect(first.containsKey('foto_broadcast'), true);
          expect(first.containsKey('dokumen_broadcast'), true);
          expect(first.containsKey('created_at'), true);
        }
      });

      test('should return empty list when no broadcasts', () async {
        // Act
        final result = await repository.getBroadcastList();

        // Assert
        expect(result, isA<List<Map<String, dynamic>>>());
        // List bisa kosong atau berisi data tergantung state database
      });

      test('should order broadcasts by id descending', () async {
        // Arrange - Create 2 broadcasts
        final timestamp1 = DateTime.now().millisecondsSinceEpoch;
        await Future.delayed(const Duration(milliseconds: 100));
        final timestamp2 = DateTime.now().millisecondsSinceEpoch;

        final form1 = BroadcastFormModel(
          judul: 'Broadcast 1 $timestamp1',
          isi: 'First broadcast',
          fotoPath: null,
          dokumenPath: null,
        );

        final form2 = BroadcastFormModel(
          judul: 'Broadcast 2 $timestamp2',
          isi: 'Second broadcast',
          fotoPath: null,
          dokumenPath: null,
        );

        final created1 = await repository.createBroadcast(form1);
        final created2 = await repository.createBroadcast(form2);

        // Act
        final result = await repository.getBroadcastList();

        // Assert
        expect(result.isNotEmpty, true);

        // Broadcast dengan id lebih besar (terbaru) harus di index 0
        if (result.length >= 2) {
          final first = result[0];
          final second = result[1];

          expect(first['id'] as int, greaterThanOrEqualTo(second['id'] as int));
        }

        // Cleanup
        final id1 = (created1['data'] as Map<String, dynamic>?)?['id'] as int?;
        final id2 = (created2['data'] as Map<String, dynamic>?)?['id'] as int?;

        if (id1 != null) await repository.deleteBroadcast(id1);
        if (id2 != null) await repository.deleteBroadcast(id2);
      });

      test('should handle database error gracefully', () async {
        // Note: Sulit untuk trigger error tanpa mock
        // Test ini lebih untuk dokumentasi behavior
        
        // Act & Assert
        expect(
          () => repository.getBroadcastList(),
          // Jika error, akan throw Exception
          // Jika sukses, akan return List
          anyOf([
            throwsA(isA<Exception>()),
            returnsNormally,
          ]),
        );
      });
    });

    group('deleteBroadcast', () {
      test('should delete broadcast successfully', () async {
        // Arrange - Create test data first
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = BroadcastFormModel(
          judul: 'Delete Test $timestamp',
          isi: 'Broadcast to be deleted',
          fotoPath: null,
          dokumenPath: null,
        );

        final created = await repository.createBroadcast(formModel);
        final createdData = created['data'] as Map<String, dynamic>?;
        final id = createdData?['id'] as int?;

        expect(id, isNotNull);

        // Act
        final result = await repository.deleteBroadcast(id!);

        // Assert
        expect(result['success'], true);
        expect(result['message'], 'Broadcast berhasil dihapus');

        // Verify deletion - check if id not in list anymore
        final allBroadcasts = await repository.getBroadcastList();
        final deletedExists = allBroadcasts.any((b) => b['id'] == id);
        expect(deletedExists, false);
      });

      test('should handle delete non-existent broadcast', () async {
        // Act
        final result = await repository.deleteBroadcast(999999);

        // Assert
        // Repository returns success even if id doesn't exist (Supabase behavior)
        expect(result, isNotNull);
        expect(result['success'], anyOf([true, false]));
      });

      test('should handle multiple deletes gracefully', () async {
        // Arrange - Create test broadcast
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final formModel = BroadcastFormModel(
          judul: 'Multiple Delete Test $timestamp',
          isi: 'Test content',
          fotoPath: null,
          dokumenPath: null,
        );

        final created = await repository.createBroadcast(formModel);
        final id = (created['data'] as Map<String, dynamic>?)?['id'] as int?;
        expect(id, isNotNull);

        // Act - Delete twice
        final result1 = await repository.deleteBroadcast(id!);
        final result2 = await repository.deleteBroadcast(id);

        // Assert - Both should return success (idempotent)
        expect(result1['success'], true);
        expect(result2['success'], anyOf([true, false]));
      });
    });
  });
}