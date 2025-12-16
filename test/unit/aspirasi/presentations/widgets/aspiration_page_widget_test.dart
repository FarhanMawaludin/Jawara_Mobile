import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jawaramobile/features/aspirasi/data/models/aspiration_model.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/providers/aspirasi_providers.dart';

void main() {
  testWidgets('AspirationPage shows list items from provider', (tester) async {
    final now = DateTime.now();
    final fakeList = [
      AspirationModel(
        id: 13,
        sender: 'wiwin@gmail.com',
        title: 'Perbaikan Jalan RT 01',
        status: 'pending',
        createdAt: now.subtract(const Duration(hours: 1)),
        message: 'Jalan RT 01 banyak lubang, mohon perbaikan',
      ),
      AspirationModel(
        id: 50,
        sender: 'fa90aa61-2219-4d85-8977-2c5fea123456',
        title: 'Air PAM putus',
        status: 'in progress',
        createdAt: now.subtract(const Duration(days: 3)),
        message: 'Air PDAM mati sejak pukul 06:00 pagi.',
      ),
    ];

    final override = aspirationListProvider.overrideWithProvider(
      FutureProvider<List<AspirationModel>>((ref) async => fakeList),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [override],
        child: const MaterialApp(home: Scaffold(body: AspirationPage())),
      ),
    );

    await tester.pumpAndSettle();

    // The list item shows sender (before @) and message preview, not the title.
    // Expect two list items to be present
    expect(find.byType(AspirationListItem), findsNWidgets(2));
    expect(find.textContaining('Jalan RT 01 banyak lubang'), findsOneWidget);
    // second item's message should also be present
    expect(find.textContaining('Air PDAM mati sejak pukul 06:00 pagi.'), findsOneWidget);
  });
}
