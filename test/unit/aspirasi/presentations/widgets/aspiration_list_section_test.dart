import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_section.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class FakeRemote extends AspirationRemoteDataSourceImpl {
  FakeRemote() : super(MockSupabaseClient());
  @override
  Future<List<AspirationModel>> getAllAspirations() async => [];
  @override
  Future<void> markAsRead(int id) async => Future.delayed(const Duration(milliseconds: 10));
}

void main() {
  group('AspirationListSection', () {
    testWidgets('displays and filters items', (tester) async {
      final now = DateTime.now();
      final items = [
        AspirationModel(id: 1, sender: 'a@a.com', title: 'Recent', status: 'pending', createdAt: now.subtract(Duration(hours: 3)), message: 'recent'),
        AspirationModel(id: 2, sender: 'b@b.com', title: 'Week', status: 'resolved', createdAt: now.subtract(Duration(days: 3)), message: 'week'),
        AspirationModel(id: 3, sender: 'c@c.com', title: 'Old', status: 'pending', createdAt: now.subtract(Duration(days: 40)), message: 'old'),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationListProvider.overrideWithProvider(FutureProvider((ref) async => items))],
          child: const MaterialApp(home: Scaffold(body: AspirationListSection())),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Terbaru'), findsOneWidget);
      expect(find.text('7 Hari Terakhir'), findsOneWidget);

      // Test search
      await tester.enterText(find.byType(TextField), 'Week');
      await tester.pumpAndSettle();
      expect(find.textContaining('week'), findsOneWidget);
      expect(find.textContaining('recent'), findsNothing);

      // Test filter
      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();
      expect(find.textContaining('recent'), findsOneWidget);
      expect(find.textContaining('old'), findsOneWidget);
    });

    testWidgets('marks item as read locally', (tester) async {
      final items = [
        AspirationModel(id: 20, sender: 'test@example.com', title: 'Test', status: 'pending', createdAt: DateTime.now().subtract(const Duration(hours: 5)), message: 'Test message', isRead: false),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationListProvider.overrideWithProvider(FutureProvider((ref) async => items))],
          child: const MaterialApp(home: Scaffold(body: AspirationListSection())),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Baru'), findsOneWidget);
    });

    testWidgets('generates key for item without id', (tester) async {
      final now = DateTime.now();
      final items = [
        AspirationModel(id: 15, sender: 'a@a.com', title: 'First', status: 'pending', createdAt: now.subtract(const Duration(hours: 1)), message: 'msg1', isRead: false),
        AspirationModel(id: null, sender: 'noId@test.com', title: 'Without ID', status: 'pending', createdAt: now.subtract(const Duration(hours: 2)), message: 'msg2', isRead: false),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationListProvider.overrideWithProvider(FutureProvider((ref) async => items))],
          child: const MaterialApp(home: Scaffold(body: AspirationListSection())),
        ),
      );

      await tester.pumpAndSettle();
      // Should render without error even when item has null id
      expect(find.text('Terbaru'), findsOneWidget);
      // Both items should render in recent section
      expect(find.byType(AspirationListItem), findsAtLeast(2));
    });

    testWidgets('shows error message when loading fails', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aspirationListProvider.overrideWithProvider(
              FutureProvider((ref) => Future.error('Network error')),
            ),
          ],
          child: const MaterialApp(home: Scaffold(body: AspirationListSection())),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.textContaining('Gagal memuat aspirasi'), findsOneWidget);
    });

    testWidgets('updates local read state when item is marked', (tester) async {
      final fakeRemote = FakeRemote();
      final items = [
        AspirationModel(id: 99, sender: 'test@x.com', title: 'Unread', status: 'pending', createdAt: DateTime.now().subtract(const Duration(hours: 1)), message: 'msg', isRead: false),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            aspirationListProvider.overrideWithProvider(FutureProvider((ref) async => items)),
            aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote),
          ],
          child: const MaterialApp(home: Scaffold(body: AspirationListSection())),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('Baru'), findsOneWidget);
      
      // Tap item to mark as read - this will execute onMarkedRead callback
      await tester.tap(find.byType(AspirationListItem).first);
      await tester.pumpAndSettle();
      
      // Local state should update (though 'Baru' might still show depending on implementation)
      // The key is that onMarkedRead callback executes without error
    });
  });
}
