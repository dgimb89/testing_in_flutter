import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartNewGameButton extends StatelessWidget {
  const StartNewGameButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: const Text('Start new game'),
      onPressed: () => context.replace('/game'),
    );
  }
}
