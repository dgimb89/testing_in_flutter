import 'package:go_router/go_router.dart';
import 'package:testing_in_flutter/screens/start_game_screen.dart';
import 'package:testing_in_flutter/screens/game_over_screen.dart';
import 'package:testing_in_flutter/screens/game_screen.dart';

// GoRouter configuration
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const StartGameScreen()),
    GoRoute(path: '/game', builder: (context, state) => const GameScreen()),
    GoRoute(
      path: '/game_over',
      builder: (context, state) {
        final score =
            int.tryParse(state.uri.queryParameters['score'] ?? '') ?? 0;
        return GameOverScreen(score);
      },
    ),
  ],
);
