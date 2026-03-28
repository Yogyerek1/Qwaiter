import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/auth_provider.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/verify_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/restaurant/screens/restaurant_shell.dart';

class AppRouter {
  static GoRouter router(AuthProvider auth) => GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final loggedIn = auth.isLoggedIn;
      final onLogin = state.matchedLocation == '/login';
      final onVerify = state.matchedLocation == '/verify';

      if (!loggedIn && !onLogin && !onVerify) return '/login';
      if (loggedIn && onLogin) return '/home';
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/verify',
        builder: (context, state) => const VerifyScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/restaurant/:id',
        builder: (context, state) =>
            RestaurantShell(restaurantId: state.pathParameters['id']!),
      ),
    ],
  );
}
