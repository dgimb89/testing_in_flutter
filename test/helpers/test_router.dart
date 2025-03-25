import 'package:go_router/go_router.dart';
import 'package:testing_in_flutter/router.dart' as app_router;

class TestRouter {
  static String currentLocation = '/';
  static final _baseRouter = app_router.router;

  static GoRouter create({String initialLocation = '/'}) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: _baseRouter.configuration.routes,
    );
  }
}
