// lib/features/onboarding/presentation/screens/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:padhai/features/onboarding/presentation/widgets/onboarding_page.dart';
import 'package:padhai/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:padhai/shared/widgets/app_button.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();

  final List<Map<String, String>> _pages = const [
    {
      'image': 'assets/images/onboarding_1.png',
      'title': 'Learn at Your Pace',
      'description':
          'Our adaptive learning system adjusts to your level, ensuring you grasp concepts before moving forward.',
    },
    {
      'image': 'assets/images/onboarding_2.png',
      'title': 'Track Your Progress',
      'description':
          'Monitor your learning journey with detailed analytics and insights to stay motivated.',
    },
    {
      'image': 'assets/images/onboarding_3.png',
      'title': 'Excel in CBSE',
      'description':
          'Comprehensive coverage of CBSE curriculum for Classes 8-12 with practice questions and mock tests.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    ref.read(onboardingProvider.notifier).setPage(page);
  }

  void _skipOnboarding() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _completeOnboarding() async {
    try {
      await ref.read(onboardingProvider.notifier).completeOnboarding();
      if (mounted) {
        context.go(AppRoute.login.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing onboarding: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _nextPage() {
    final currentPage = ref.read(onboardingProvider).currentPage;
    if (currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingProvider);
    final isLastPage = state.currentPage == _pages.length - 1;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            if (!isLastPage)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            // Page view
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    image: page['image']!,
                    title: page['title']!,
                    description: page['description']!,
                  );
                },
              ),
            ),
            // Indicators and button
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                children: [
                  PageIndicator(
                    currentPage: state.currentPage,
                    pageCount: _pages.length,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  AppButton(
                    text: isLastPage ? 'Get Started' : 'Next',
                    onPressed: state.isLoading ? null : _nextPage,
                    isLoading: state.isLoading,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
