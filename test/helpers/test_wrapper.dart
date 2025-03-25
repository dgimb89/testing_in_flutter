import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'test_router.dart';

/// A helper widget that wraps test widgets with necessary providers and routing
Widget createTestWidget({
  Widget? child,
  String initialLocation = '/',
  ProviderContainer? container,
}) {
  return UncontrolledProviderScope(
    container: container ?? ProviderContainer(),
    child: MaterialApp.router(
      routerConfig: TestRouter.create(initialLocation: initialLocation),
    ),
  );
}

/// A helper widget that wraps test widgets with necessary providers but without routing
/// Use this when testing individual widgets that don't need routing
Widget createTestWidgetWithoutRouting({required Widget child}) {
  return UncontrolledProviderScope(
    container: ProviderContainer(),
    child: MaterialApp(home: child),
  );
}
