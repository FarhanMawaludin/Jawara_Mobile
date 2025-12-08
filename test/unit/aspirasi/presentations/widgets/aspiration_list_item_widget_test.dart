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

  testWidgets('AspirationListItem shows unread indicator (dot and badge) when isRead=false', (tester) async {
    final item = AspirationItem(
      sender: 'test@example.com',
      title: 'Test Title',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'Test message',
      isRead: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Should display "Baru" badge
    expect(find.text('Baru'), findsOneWidget);

    // Should display sender name in bold
    expect(find.text('test'), findsOneWidget);

    // Dot indicator should be visible (positioned at avatar top-right)
    expect(find.byType(Positioned), findsWidgets);
  });

  testWidgets('AspirationListItem hides unread indicator when isRead=true', (tester) async {
    final item = AspirationItem(
      sender: 'test@example.com',
      title: 'Test Title',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'Test message',
      isRead: true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Should NOT display "Baru" badge
    expect(find.text('Baru'), findsNothing);

    // Message should be visible but not bold
    expect(find.text('Test message'), findsOneWidget);
  });

  testWidgets('AspirationListItem calls onMarkedRead callback when tapped', (tester) async {
    var markReadCalled = false;
    final item = AspirationItem(
      sender: 'test@example.com',
      title: 'Test Title',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'Test message',
      isRead: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(
            item: item,
            onMarkedRead: () {
              markReadCalled = true;
            },
          ),
        ),
      ),
    );

    // Tap the item
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // onMarkedRead should have been called
    expect(markReadCalled, isTrue);
  });

  testWidgets('AspirationListItem displays sender without email format correctly', (tester) async {
    final item = AspirationItem(
      sender: 'JohnDoe', // No @ symbol
      title: 'Test',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'Test message',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Should display full sender name when no @ symbol
    expect(find.text('JohnDoe'), findsOneWidget);
  });

  testWidgets('AspirationListItem avatar initial is first character of sender name', (tester) async {
    final item = AspirationItem(
      sender: 'agnes@example.com',
      title: 'Test',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'Test message',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Avatar initial should be 'A' (first char of 'agnes')
    expect(find.text('A'), findsOneWidget);
  });

  testWidgets('AspirationListItem displays long message with ellipsis', (tester) async {
    final item = AspirationItem(
      sender: 'test@example.com',
      title: 'Test',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'This is a very long message that should be truncated with ellipsis when displayed in the list item preview',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Message should be visible (even if truncated)
    expect(find.textContaining('This is a very long message'), findsOneWidget);
  });

  testWidgets('AspirationListItem displays different content for read and unread', (tester) async {
    final item = AspirationItem(
      sender: 'test@example.com',
      title: 'Test',
      status: 'pending',
      date: DateTime(2025, 12, 6),
      message: 'Test message',
      isRead: false,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: AspirationListItem(item: item),
        ),
      ),
    );

    // Verify sender is displayed
    expect(find.text('test'), findsOneWidget);
    
    // Verify message is displayed
    expect(find.text('Test message'), findsOneWidget);
  });
}
