// lib/features/auth/presentation/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/storage/secure_storage.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/core/di/injection.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final secureStorage = getIt<SecureStorage>();
    final hasCompletedOnboarding =
        await secureStorage.hasCompletedOnboarding();
    final authState = ref.read(authProvider);

    if (!mounted) return;

    if (!hasCompletedOnboarding) {
      context.go(AppRoute.onboarding.path);
    } else if (authState.isAuthenticated) {
      context.go(AppRoute.dashboard.path);
    } else {
      context.go(AppRoute.login.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.school,
                size: 64,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Padhai',
              style: AppTypography.h1.copyWith(
                color: AppColors.textOnPrimary,
                fontSize: 36,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'पढ़ाई',
              style: AppTypography.h3.copyWith(
                color: AppColors.primaryLight,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.surface),
            ),
          ],
        ),
      ),
    );
  }
}
