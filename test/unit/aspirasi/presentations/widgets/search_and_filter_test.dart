import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/search_bar.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/filter_dialog.dart';

void main() {
  group('AspirationSearchBar', () {
    testWidgets('shows clear icon and clears text', (tester) async {
      final controller = TextEditingController(text: 'hello');
      String last = 'init';

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: AspirationSearchBar(controller: controller, onFilterTap: () {}, onSearchChanged: (s) => last = s)),
      ));

      expect(find.byIcon(Icons.close), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(controller.text, isEmpty);
      expect(last, isEmpty);
    });

    testWidgets('calls onSearchChanged', (tester) async {
      final controller = TextEditingController();
      String? lastQuery;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: AspirationSearchBar(controller: controller, onFilterTap: () {}, onSearchChanged: (s) => lastQuery = s)),
      ));

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pumpAndSettle();
      expect(lastQuery, 'test');
    });

    testWidgets('filter button works', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: AspirationSearchBar(controller: TextEditingController(), onFilterTap: () => tapped = true, onSearchChanged: (_) {})),
      ));

      await tester.tap(find.byIcon(Icons.filter_list));
      await tester.pumpAndSettle();
      expect(tapped, isTrue);
    });
  });

  group('FilterDialog', () {
    testWidgets('shows options and applies selection', (tester) async {
      String? applied;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showAspirationFilterDialog(context, currentStatus: 'All', onApply: (s) => applied = s),
              child: const Text('Open'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      expect(find.text('Filter Aspirasi'), findsOneWidget);

      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();
      expect(applied, 'Pending');
    });

    testWidgets('reset button sets to All', (tester) async {
      String? applied;

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: ElevatedButton(
              onPressed: () => showAspirationFilterDialog(context, currentStatus: 'Pending', onApply: (s) => applied = s),
              child: const Text('Open'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Reset filter'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();
      expect(applied, 'All');
    });
  });
}
