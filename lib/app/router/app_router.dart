// lib/app/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        builder: (context, state) => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
      ),
      GoRoute(
        path: AppRoute.onboarding.path,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Onboarding')),
        ),
      ),
      GoRoute(
        path: AppRoute.login.path,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Login')),
        ),
      ),
      GoRoute(
        path: AppRoute.register.path,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Register')),
        ),
      ),
      GoRoute(
        path: AppRoute.dashboard.path,
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Dashboard')),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
