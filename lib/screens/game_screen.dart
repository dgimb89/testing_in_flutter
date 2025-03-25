import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import 'package:testing_in_flutter/common/widgets/title_bar.dart';
import 'package:testing_in_flutter/view_models/game_screen_view_model.dart';

class GameScreen extends ConsumerStatefulWidget {
  static const targetFrameRate = 60;
  static const buttonSize = 80.0;
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late Timer _frameTimer;

  @override
  void initState() {
    super.initState();

    // set up frame loop by timer signal
    _frameTimer = Timer.periodic(
      Duration(milliseconds: (1000 / GameScreen.targetFrameRate).toInt()),
      (Timer timer) {
        setState(() {});
      },
    );
  }

  @override
  void dispose() {
    _frameTimer.cancel();
    super.dispose();
  }

  /// Cancels the frame timer
  ///
  /// This method should only be used in tests to prevent timer leaks
  @visibleForTesting
  void cancelTimerForTesting() {
    _frameTimer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameScreenProvider);
    final viewModel = ref.read(gameScreenProvider.notifier);

    if (gameState.isGameOver) {
      _frameTimer.cancel();

      Future.microtask(() {
        if (context.mounted) {
          context.replace('/game_over?score=${gameState.clickCounter}');
        }
      });
    }

    final body = _buildCatchButton(viewModel);
    return Scaffold(
      appBar: TitleBar(context, 'Catch the button!'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Score: ${gameState.clickCounter}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 10,
                      children: List.generate(100, (index) {
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.2),
                            ),
                          ),
                        );
                      }),
                    ),
                    // Overlay text
                    if (gameState.pacing != null &&
                        gameState.previousX != null &&
                        gameState.previousY != null)
                      Positioned(
                        left: (gameState.previousX! *
                                (constraints.maxWidth - GameScreen.buttonSize))
                            .clamp(0, constraints.maxWidth - 50),
                        top: (gameState.previousY! *
                                    (constraints.maxHeight -
                                        GameScreen.buttonSize) -
                                20)
                            .clamp(0, constraints.maxHeight - 30),
                        child: Text(
                          '${gameState.pacing! > 0 ? '+' : ''}${gameState.pacing!.toStringAsFixed(2)}s next',
                          style: TextStyle(
                            fontSize: 12,
                            color: _getColorForTimeDifference(
                              gameState.pacing!,
                            ),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      left:
                          gameState.buttonX *
                          (constraints.maxWidth - GameScreen.buttonSize),
                      top:
                          gameState.buttonY *
                          (constraints.maxHeight - GameScreen.buttonSize),
                      child: body,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatchButton(GameScreenViewModel viewModel) {
    return Semantics(
      label: 'catch_button',
      child: SizedBox(
        width: GameScreen.buttonSize,
        height: GameScreen.buttonSize,
        child: ElevatedButton(
          onPressed: viewModel.signalCatch,
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(16),
          ),
          child: Text(
            viewModel.getRemainingSeconds().toStringAsFixed(2),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  static const _playerTooSlow = 0.0;
  static const _playerOnTarget = 1.0;
  static const _playerAhead = 2.0;

  Color _getColorForTimeDifference(double timeDifference) {
    if (timeDifference <= _playerTooSlow) return Colors.red;
    if (timeDifference >= _playerAhead) return Colors.green;

    if (timeDifference <= _playerOnTarget) {
      // Interpolate between red and orange
      double t = timeDifference; // 0.0 to 1.0
      return Color.lerp(Colors.red, Colors.orange, t)!;
    } else {
      // Interpolate between orange and green
      double t = (timeDifference - _playerOnTarget); // 0.0 to 1.0
      return Color.lerp(Colors.orange, Colors.green, t)!;
    }
  }
}
