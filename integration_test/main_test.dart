import 'package:testing_in_flutter/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  group('Game Flow Integration Tests', () {
    testWidgets('Play a game', (tester) async {
      await tester.pumpWidget(app.buildProviderScope());
      await tester.pumpAndSettle();

      // Verify welcome screen
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Ready to Play?'), findsOneWidget);

      // Start the game
      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      // Verify game screen
      expect(find.text('Catch the button!'), findsOneWidget);
      expect(find.text('Score: 0'), findsOneWidget);

      // Catch the button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify score increased
      expect(find.text('Score: 1'), findsOneWidget);

      // while finding the button, press it
      while (find.bySemanticsLabel('catch_button').evaluate().isNotEmpty) {
        await tester.tap(find.bySemanticsLabel('catch_button'));
        await tester.pumpAndSettle();
      }

      // Verify game over screen
      expect(find.text('Game over'), findsOneWidget);
      expect(find.text('Final Score'), findsOneWidget);

      await tester.tap(find.text('Start Game'));
      await tester.pumpAndSettle();

      expect(find.text('Catch the button!'), findsOneWidget);
      expect(find.text('Score: 0'), findsOneWidget);
    });
  });
}
