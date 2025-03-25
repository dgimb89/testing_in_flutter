import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_wrapper.dart';

void main() {
  group('StartGameScreen', () {
    testWidgets('is the default route', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      // Verify that the player is greeted properly
      expect(find.text('Welcome'), findsOneWidget);
    });

    testWidgets('renders start game button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());
      expect(find.text('Start Game'), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('navigates to game screen when Start Game is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Tap the start game button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify we're on the game screen by looking for the game screen title
      expect(find.text('Catch the button!'), findsOneWidget);
    });
  });
}
