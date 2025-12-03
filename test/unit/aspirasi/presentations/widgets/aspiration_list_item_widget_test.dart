import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_list_item.dart';
import 'package:jawaramobile/features/aspirasi/presentations/pages/methods/aspiration_model.dart';

void main() {
  testWidgets('AspirationListItem displays sender initial, sender name, message and formatted date', (tester) async {
    final item = AspirationItem(
      sender: 'wiwin@gmail.com',
      title: 'Perbaikan Jalan RT 01',
      status: 'pending',
      date: DateTime(2025, 11, 22),
      message: 'Jalan RT 01 banyak lubang, mohon perbaikan',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Avatar initial 'W' from 'wiwin'
    expect(find.text('W'), findsOneWidget);

    // Sender display name (part before @)
    expect(find.text('wiwin'), findsOneWidget);

    // Message preview
    expect(find.textContaining('Jalan RT 01 banyak lubang'), findsOneWidget);

    // Formatted date '22 November 2025'
    expect(find.text('22 November 2025'), findsOneWidget);
  });
}
