import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/login_page.dart';
import '../../features/landing/presentation/landing_page.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import 'route_paths.dart';

class AppRouter {
  static GoRouter buildRouter() {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      routes: [
        GoRoute(
          path: RoutePaths.landing,
          builder: (context, state) => const LandingPage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashScreen(),
        ),
      ],
    );
  }
}
