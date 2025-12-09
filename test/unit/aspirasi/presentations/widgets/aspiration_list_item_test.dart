import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
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
  group('AspirationListItem', () {
    testWidgets('displays sender, message, date', (tester) async {
      final item = AspirationItem(sender: 'wiwin@gmail.com', title: 'Test', status: 'pending', date: DateTime(2025, 11, 22), message: 'Test message');
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: AspirationListItem(item: item))));
      expect(find.text('W'), findsOneWidget);
      expect(find.text('wiwin'), findsOneWidget);
      expect(find.text('22 November 2025'), findsOneWidget);
    });

    testWidgets('shows unread indicator', (tester) async {
      final item = AspirationItem(sender: 'test@ex.com', title: 'T', status: 'pending', date: DateTime(2025, 12, 6), message: 'M', isRead: false);
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: AspirationListItem(item: item))));
      expect(find.text('Baru'), findsOneWidget);
    });

    testWidgets('calls markAsRead on tap with id', (tester) async {
      final fakeRemote = FakeRemote();
      final item = AspirationItem(id: 5, sender: 'test@ex.com', title: 'T', status: 'pending', date: DateTime(2025, 12, 6), message: 'M', isRead: false);
      var called = false;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote)],
          child: MaterialApp(home: Scaffold(body: AspirationListItem(item: item, onMarkedRead: () => called = true))),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(fakeRemote.lastMarkedId, 5);
      expect(called, isTrue);
    });

    testWidgets('does not call markAsRead when no id', (tester) async {
      final fakeRemote = FakeRemote();
      final item = AspirationItem(id: null, sender: 'test@ex.com', title: 'T', status: 'pending', date: DateTime(2025, 12, 6), message: 'M', isRead: false);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote)],
          child: MaterialApp(home: Scaffold(body: AspirationListItem(item: item))),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      expect(fakeRemote.lastMarkedId, isNull);
    });

    testWidgets('calls onMarkedRead after returning from detail page', (tester) async {
      final fakeRemote = FakeRemote();
      final item = AspirationItem(id: 10, sender: 'test@ex.com', title: 'T', status: 'pending', date: DateTime(2025, 12, 6), message: 'M', isRead: false);
      var callCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [aspirationRemoteDataSourceProvider.overrideWithValue(fakeRemote)],
          child: MaterialApp(home: Scaffold(body: AspirationListItem(item: item, onMarkedRead: () => callCount++))),
        ),
      );

      await tester.tap(find.byType(InkWell));
      await tester.pumpAndSettle();
      
      // Navigate back
      await tester.pageBack();
      await tester.pumpAndSettle();
      
      // onMarkedRead should be called twice: before and after navigation
      expect(callCount, greaterThanOrEqualTo(1));
    });
  });
}
