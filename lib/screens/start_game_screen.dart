import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:testing_in_flutter/common/widgets/start_new_game_button.dart';
import 'package:testing_in_flutter/common/widgets/title_bar.dart';

class StartGameScreen extends StatelessWidget {
  const StartGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar(context, 'Welcome'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Ready to Play?',
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
              child: StartNewGameButton(),
            ),
          ],
        ),
      ),
    );
  }
}
