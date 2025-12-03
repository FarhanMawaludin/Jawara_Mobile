import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/search_bar.dart';

void main() {
  testWidgets('Search bar shows clear icon when text present and clears on tap', (tester) async {
    final controller = TextEditingController(text: 'hello');
    String last = 'init';
    bool filterTapped = false;

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AspirationSearchBar(
          controller: controller,
          onFilterTap: () => filterTapped = true,
          onSearchChanged: (s) => last = s,
        ),
      ),
    ));

    // clear icon should be visible
    expect(find.byIcon(Icons.close), findsOneWidget);

    await tester.tap(find.byIcon(Icons.close));
    await tester.pumpAndSettle();

    expect(controller.text, '');
    expect(last, '');

    // filter button should call callback
    await tester.tap(find.byIcon(Icons.filter_list));
    await tester.pumpAndSettle();
    expect(filterTapped, isTrue);
  });
}
