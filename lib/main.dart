import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_in_flutter/router.dart' show router;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(buildProviderScope());
}

@visibleForTesting
ProviderScope buildProviderScope() {
  return ProviderScope(child: ClickerGameApp());
}

class ClickerGameApp extends StatelessWidget {
  const ClickerGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(routerConfig: router);
  }
}
