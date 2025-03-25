import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

// State class to hold all the game state
class GameState {
  final int clickCounter;
  final double buttonX;
  final double buttonY;
  final double? previousX;
  final double? previousY;
  final double? pacing;
  final DateTime catchBy;

  const GameState({
    required this.clickCounter,
    required this.buttonX,
    required this.buttonY,
    this.previousX,
    this.previousY,
    this.pacing,
    required this.catchBy,
  });

  GameState copyWith({
    int? clickCounter,
    double? buttonX,
    double? buttonY,
    double? previousX,
    double? previousY,
    double? timeDifference,
    DateTime? catchBy,
  }) {
    return GameState(
      clickCounter: clickCounter ?? this.clickCounter,
      buttonX: buttonX ?? this.buttonX,
      buttonY: buttonY ?? this.buttonY,
      previousX: previousX ?? this.previousX,
      previousY: previousY ?? this.previousY,
      pacing: timeDifference ?? this.pacing,
      catchBy: catchBy ?? this.catchBy,
    );
  }

  bool get isGameOver => DateTime.now().isAfter(catchBy);
}

class GameScreenViewModel extends StateNotifier<GameState> {
  final int initialCatchTime = 10_000;
  final double catchTimeFactor = 0.9;
  final double minimumDistanceFromPreviousPosition = 0.3;

  GameScreenViewModel()
    : super(
        GameState(
          clickCounter: 0,
          buttonX: 0,
          buttonY: 0,
          catchBy: DateTime.now().add(const Duration(milliseconds: 10_000)),
        ),
      ) {
    _initGame();
  }

  void _initGame() {
    _randomizeButtonPosition();
    _setupCatchDeadline();
  }

  void _randomizeButtonPosition() {
    double newX, newY;
    double distance;
    do {
      newX = Random().nextDouble();
      newY =
          0.04 +
          Random().nextDouble() *
              0.96; // leave upper 4% of the screen for the UI
      distance = sqrt(
        pow(newX - state.buttonX, 2) + pow(newY - state.buttonY, 2),
      );
    } while (distance < minimumDistanceFromPreviousPosition);

    state = state.copyWith(buttonX: newX, buttonY: newY);
  }

  void _setupCatchDeadline() {
    final catchBy = DateTime.now().add(
      Duration(
        milliseconds:
            (initialCatchTime * pow(catchTimeFactor, state.clickCounter))
                .toInt(),
      ),
    );
    state = state.copyWith(catchBy: catchBy);
  }

  void signalCatch() {
    final nextCatchTime =
        (initialCatchTime * pow(catchTimeFactor, state.clickCounter + 1))
            .toInt();

    final timeToCatchLastButton =
        state.catchBy.difference(DateTime.now()).inMilliseconds;
    final actualTimeTaken =
        initialCatchTime * pow(catchTimeFactor, state.clickCounter) -
        timeToCatchLastButton;

    final timeDifference = (nextCatchTime - actualTimeTaken) / 1000.0;

    state = state.copyWith(
      previousX: state.buttonX,
      previousY: state.buttonY,
      timeDifference: timeDifference,
      clickCounter: state.clickCounter + 1,
    );

    _randomizeButtonPosition();
    _setupCatchDeadline();
  }

  double getRemainingSeconds() {
    return max(
      state.catchBy.difference(DateTime.now()).inMilliseconds.toDouble() / 1000,
      0,
    );
  }
}

// Provider definition
final gameScreenProvider =
    StateNotifierProvider.autoDispose<GameScreenViewModel, GameState>((ref) {
      return GameScreenViewModel();
    });
