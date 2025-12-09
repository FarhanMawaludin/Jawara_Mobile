import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/filter_dialog.dart';

void main() {
  group('showAspirationFilterDialog', () {
    testWidgets('displays filter options and applies selection', (tester) async {
      var appliedStatus = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await showAspirationFilterDialog(
                    context,
                    currentStatus: 'All',
                    onApply: (status) => appliedStatus = status,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      expect(find.text('Filter Aspirasi'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Pending'), findsOneWidget);

      // Select Pending
      await tester.tap(find.text('Pending'));
      await tester.pumpAndSettle();

      // Apply
      await tester.tap(find.text('Terapkan'));
      await tester.pumpAndSettle();

      expect(appliedStatus, 'Pending');
    });

    testWidgets('cancel button closes dialog without applying', (tester) async {
      var appliedStatus = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await showAspirationFilterDialog(
                    context,
                    currentStatus: 'All',
                    onApply: (status) => appliedStatus = status,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap cancel button
      await tester.tap(find.text('Batal'));
      await tester.pumpAndSettle();

      // onApply should not be called
      expect(appliedStatus, '');
      expect(find.text('Filter Aspirasi'), findsNothing);
    });

    testWidgets('reset button sets filter to All', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  await showAspirationFilterDialog(
                    context,
                    currentStatus: 'Pending',
                    onApply: (status) {},
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();

      // Tap reset
      await tester.tap(find.text('Reset filter'));
      await tester.pumpAndSettle();

      // Should select 'All'
      expect(find.text('All'), findsWidgets);
    });
  });
}
