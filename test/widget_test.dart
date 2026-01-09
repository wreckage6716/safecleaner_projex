// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:safecleaner_pro/main.dart';
import 'package:safecleaner_pro/screens/main_screen.dart';

void main() {
  testWidgets('App builds and shows MainScreen', (WidgetTester tester) async {
    // Build app
    await tester.pumpWidget(const SafeCleanerApp());

    // Allow any async init to complete
    await tester.pumpAndSettle();

    // Verify MainScreen is present
    expect(find.byType(MainScreen), findsOneWidget);
  });
}
