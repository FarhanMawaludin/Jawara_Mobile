import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/data/datasources/aspiration_remote_datasource.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseClient extends Mock implements SupabaseClient {}

class FakeRemote extends AspirationRemoteDataSourceImpl {
  int? lastMarkedId;
  FakeRemote() : super(MockSupabaseClient());
  @override
  Future<List<AspirationModel>> getAllAspirations() async => [];
  @override
  Future<void> markAsRead(int id) async {
    lastMarkedId = id;
    await Future.delayed(const Duration(milliseconds: 10));
  }
}

void main() {
  group('AspirationDetailPage', () {
    testWidgets('displays content and timeAgo', (tester) async {
      final now = DateTime.now();
      final item = AspirationItem(sender: 'user@ex.com', title: 'Test Title', status: 'pending', date: now.subtract(const Duration(seconds: 10)), message: 'Test message');
      await tester.pumpWidget(MaterialApp(home: AspirationDetailPage(item: item)));
      await tester.pumpAndSettle();
      expect(find.text('Test Title'), findsOneWidget);
      expect(find.text('user@ex.com'), findsOneWidget);
      expect(find.textContaining('baru saja'), findsOneWidget);
    });

    testWidgets('displays formatDate for dates older than 7 days', (tester) async {
      final oldDate = DateTime.now().subtract(const Duration(days: 10));
      final item = AspirationItem(sender: 'test@ex.com', title: 'Old Title', status: 'done', date: oldDate, message: 'Old message');
      await tester.pumpWidget(MaterialApp(home: AspirationDetailPage(item: item)));
      await tester.pumpAndSettle();
      expect(find.text('Old Title'), findsOneWidget);
      // Should show formatted date, not "hari yang lalu"
      expect(find.textContaining('hari yang lalu'), findsNothing);
    });

    testWidgets('calls markAsRead on init when unread', (tester) async {
      final fakeRemote = FakeRemote();
      final item = AspirationItem(id: 7, sender: 'user@ex.com', title: 'Test', status: 'pending', date: DateTime.now(), message: 'Msg', isRead: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote)],
          child: MaterialApp(home: AspirationDetailPage(item: item)),
        ),
      );

      await tester.pumpAndSettle();
      expect(fakeRemote.lastMarkedId, 7);
    });

    testWidgets('does not call markAsRead when already read', (tester) async {
      final fakeRemote = FakeRemote();
      final item = AspirationItem(id: 8, sender: 'user@ex.com', title: 'Test', status: 'pending', date: DateTime.now(), message: 'Msg', isRead: true);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote)],
          child: MaterialApp(home: AspirationDetailPage(item: item)),
        ),
      );

      await tester.pumpAndSettle();
      expect(fakeRemote.lastMarkedId, isNull);
    });
  });
}
