import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_section.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';

void main() {
  testWidgets('AspirationListSection filters by query and status, groups items', (tester) async {
    final now = DateTime.now();
    final items = [
      // recent (within 24h)
      AspirationModel(id: 1, sender: 'a@a.com', title: 'Recent issue', status: 'pending', createdAt: now.subtract(Duration(hours: 3)), message: 'recent message'),
      // within week
      AspirationModel(id: 2, sender: 'b@b.com', title: 'Week issue', status: 'resolved', createdAt: now.subtract(Duration(days: 3)), message: 'week message'),
      // older
      AspirationModel(id: 3, sender: 'c@c.com', title: 'Old issue', status: 'pending', createdAt: now.subtract(Duration(days: 40)), message: 'old message'),
    ];

    final override = aspirationListProvider.overrideWithProvider(
      FutureProvider<List<AspirationModel>>((ref) async => items),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: const MaterialApp(home: Scaffold(body: AspirationListSection())),
      ),
    );

    // wait for provider to resolve
    await tester.pumpAndSettle();

    // Should show section 'Terbaru' for the recent item
    expect(find.text('Terbaru'), findsOneWidget);
    // Should show '7 Hari Terakhir' for week items
    expect(find.text('7 Hari Terakhir'), findsOneWidget);

    // Now test search: enter query matching 'week'
    final finder = find.byType(TextField);
    expect(finder, findsOneWidget);
    await tester.enterText(finder, 'Week');
    await tester.pumpAndSettle();

    // After searching 'Week', only week item should be visible (message present)
    expect(find.textContaining('week message'), findsOneWidget);
    expect(find.textContaining('recent message'), findsNothing);

    // Open filter dialog and set filter to 'Pending'
    final filterButton = find.byIcon(Icons.filter_list);
    expect(filterButton, findsOneWidget);
    await tester.tap(filterButton);
    await tester.pumpAndSettle();

    // In dialog, tap 'Pending' radio and 'Terapkan'
    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terapkan'));
    await tester.pumpAndSettle();

    // Now only items with status 'pending' should appear (search still applied -> none)
    expect(find.textContaining('week message'), findsNothing);

    // Clear search
    await tester.enterText(finder, '');
    await tester.pumpAndSettle();

    // Now pending items within displayed sections should be visible.
    // The implementation shows 'Terbaru', '7 Hari Terakhir', and older date sections,
    // so the 'old message' (>7 days) is rendered under its calendar date section.
    expect(find.textContaining('recent message'), findsOneWidget);
    expect(find.textContaining('old message'), findsOneWidget);
  });
}
