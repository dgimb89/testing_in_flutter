import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_in_flutter/view_models/game_screen_view_model.dart';
import '../helpers/test_wrapper.dart';
import '../helpers/test_helpers.dart';

// Mock provider to override the game screen provider for testing
final mockGameScreenProvider =
    StateNotifierProvider.autoDispose<GameScreenViewModel, GameState>((ref) {
      return GameScreenViewModel();
    });

void main() {
  group('GameScreen', () {
    late ProviderContainer container;
    late GameScreenViewModel viewModel;

    setUp(() {
      viewModel = GameScreenViewModel();
      container = ProviderContainer(
        overrides: [gameScreenProvider.overrideWith((ref) => viewModel)],
      );
    });

    tearDown(() {
      container.dispose();
    });

    group('View', () {
      testWidgets('renders correct screen', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(initialLocation: '/game', container: container),
        );
        expect(find.text('Catch the button!'), findsOneWidget);

        // Cancel timer to prevent leaks
        await tester.cancelGameScreenTimer();
      });

      testWidgets('renders initial game state correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(initialLocation: '/game', container: container),
        );

        // Initial score should be 0
        final gameState = container.read(gameScreenProvider);
        expect(gameState.clickCounter, equals(0));

        // Verify the score is displayed
        expect(find.text('Score: 0'), findsOneWidget);

        // Verify the game grid is rendered
        expect(find.byType(GridView), findsOneWidget);

        // Verify the catch button is rendered
        expect(find.byType(ElevatedButton), findsOneWidget);

        // Cancel timer to prevent leaks
        await tester.cancelGameScreenTimer();
      });

      testWidgets('button moves when clicked', (WidgetTester tester) async {
        await tester.pumpWidget(
          createTestWidget(initialLocation: '/game', container: container),
        );

        // Get initial button position
        final gameState = container.read(gameScreenProvider);
        final initialX = gameState.buttonX;
        final initialY = gameState.buttonY;

        // Click the button
        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        // Get new position
        final newGameState = container.read(gameScreenProvider);

        // Verify button has moved
        expect(newGameState.buttonX, isNot(equals(initialX)));
        expect(newGameState.buttonY, isNot(equals(initialY)));

        // Verify score increased
        expect(newGameState.clickCounter, equals(1));

        // Cancel timer to prevent leaks
        await tester.cancelGameScreenTimer();
      });

      testWidgets('shows pacing overlay after click', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(initialLocation: '/game', container: container),
        );

        // Initially, there should be no pacing overlay
        expect(find.textContaining('s next'), findsNothing);

        // Click the button
        await tester.tap(find.byType(ElevatedButton));
        await tester.pump();

        // Now we should see the pacing overlay
        expect(find.textContaining('s next'), findsOneWidget);

        // Cancel timer to prevent leaks
        await tester.cancelGameScreenTimer();
      });

      testWidgets('navigates to game over when time runs out', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createTestWidget(initialLocation: '/game', container: container),
        );

        expect(find.text('Catch the button!'), findsOneWidget);

        viewModel.state = viewModel.state.copyWith(
          catchBy: DateTime.now().subtract(const Duration(milliseconds: 300)),
        );
        await tester.pumpAndSettle();

        // Verify we're no longer on the game screen
        expect(find.text('Catch the button!'), findsNothing);

        // Verify we're on the game over screen
        expect(find.text('Game over'), findsOneWidget);
        expect(find.text('Final Score'), findsOneWidget);
      });
    });
    group('GameScreenViewModel', () {
      test('initial state is correct', () {
        expect(viewModel.state.clickCounter, equals(0));
        expect(viewModel.state.buttonX, isNotNull);
        expect(viewModel.state.buttonY, isNotNull);
      });

      test('getRemainingSeconds never returns negative value', () {
        viewModel.state = viewModel.state.copyWith(
          catchBy: DateTime.now().subtract(const Duration(seconds: 10)),
        );
        expect(viewModel.getRemainingSeconds(), equals(0));
      });

      test('isGameOver returns true when catchBy is in the past', () {
        viewModel.state = viewModel.state.copyWith(
          catchBy: DateTime.now().subtract(const Duration(seconds: 10)),
        );
        expect(viewModel.state.isGameOver, isTrue);
      });

      test('isGameOver returns false when catchBy is in the future', () {
        viewModel.state = viewModel.state.copyWith(
          catchBy: DateTime.now().add(const Duration(seconds: 2)),
        );
        expect(viewModel.state.isGameOver, isFalse);
      });

      test('reduces catch time with each catch', () {
        // Test catch time decreases with each catch
        var initialCatchTime = viewModel.initialCatchTime;
        var catchBy = viewModel.state.catchBy.difference(DateTime.now());
        expect(catchBy.inMilliseconds, lessThanOrEqualTo(initialCatchTime));

        var previousCatchBy = catchBy;
        final catchCount = 3;
        for (int i = 0; i < catchCount; i++) {
          viewModel.signalCatch();
          catchBy = viewModel.state.catchBy.difference(DateTime.now());
          expect(
            catchBy.inMilliseconds,
            lessThan(previousCatchBy.inMilliseconds),
          );
          previousCatchBy = catchBy;
        }
      });
    });
  });
}
