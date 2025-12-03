import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/aspiration_detail.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';

Widget makeTestable(AspirationItem item) {
  return MaterialApp(
    home: AspirationDetailPage(item: item),
  );
}

AspirationItem makeItemWithDate(DateTime d) => AspirationItem(
      sender: 'tester',
      title: 'T',
      status: 'pending',
      date: d,
      message: 'M',
    );

void main() {
  testWidgets('timeAgo shows "baru saja" for seconds', (tester) async {
    final now = DateTime.now();
    final item = makeItemWithDate(now.subtract(const Duration(seconds: 30)));
    await tester.pumpWidget(makeTestable(item));
    await tester.pumpAndSettle();

    expect(find.textContaining('baru saja'), findsOneWidget);
  });

  testWidgets('timeAgo shows minutes text', (tester) async {
    final now = DateTime.now();
    final item = makeItemWithDate(now.subtract(const Duration(minutes: 5)));
    await tester.pumpWidget(makeTestable(item));
    await tester.pumpAndSettle();

    expect(find.textContaining('menit yang lalu'), findsOneWidget);
  });

  testWidgets('timeAgo shows hours text', (tester) async {
    final now = DateTime.now();
    final item = makeItemWithDate(now.subtract(const Duration(hours: 3)));
    await tester.pumpWidget(makeTestable(item));
    await tester.pumpAndSettle();

    expect(find.textContaining('jam yang lalu'), findsOneWidget);
  });

  testWidgets('timeAgo shows days text', (tester) async {
    final now = DateTime.now();
    final item = makeItemWithDate(now.subtract(const Duration(days: 2)));
    await tester.pumpWidget(makeTestable(item));
    await tester.pumpAndSettle();

    expect(find.textContaining('hari yang lalu'), findsOneWidget);
  });

  testWidgets('timeAgo falls back to formatted date for older than a week', (tester) async {
    final now = DateTime.now();
    final item = makeItemWithDate(now.subtract(const Duration(days: 10)));
    await tester.pumpWidget(makeTestable(item));
    await tester.pumpAndSettle();

    // fallback uses formatDate which produces a day-month-year string; check for year
    expect(find.textContaining('${item.date.year}'), findsOneWidget);
  });
}
