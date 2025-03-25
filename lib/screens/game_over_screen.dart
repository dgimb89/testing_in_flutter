import 'package:flutter/material.dart';
import 'package:testing_in_flutter/common/widgets/start_new_game_button.dart';
import 'package:testing_in_flutter/common/widgets/title_bar.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen(this.score, {super.key});

  final int score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(context, 'Game over'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Final Score',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                score.toString(),
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 32),
            const StartNewGameButton(),
          ],
        ),
      ),
    );
  }
}
