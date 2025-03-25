import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_in_flutter/screens/game_screen.dart';

/// Helper extension to find and interact with widget state during tests
extension WidgetTesterExtension on WidgetTester {
  /// Finds the first GameScreen state and cancels its timer
  ///
  /// This should be called at the end of tests that use the GameScreen
  /// to prevent timer leaks that cause test failures
  Future<void> cancelGameScreenTimer() async {
    final element = find.byType(GameScreen).evaluate().first as StatefulElement;

    // Use dynamic to access the method on the private state class
    (element.state as dynamic).cancelTimerForTesting();

    // Pump one more frame to process the timer cancellation
    await pumpAndSettle();
  }
}
