import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartNewGameButton extends StatelessWidget {
  const StartNewGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => context.replace('/game'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
      child: const Text(
        'Start Game',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
