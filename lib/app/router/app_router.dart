// lib/app/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/features/auth/presentation/screens/login_screen.dart';
import 'package:padhai/features/auth/presentation/screens/register_screen.dart';
import 'package:padhai/features/auth/presentation/screens/splash_screen.dart';
import 'package:padhai/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:padhai/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:padhai/features/subjects/presentation/screens/subject_detail_screen.dart';
import 'package:padhai/features/chapters/presentation/screens/chapter_detail_screen.dart';
import 'package:padhai/features/study_materials/presentation/screens/study_materials_screen.dart';
import 'package:padhai/features/practice/presentation/screens/practice_mode_screen.dart';
import 'package:padhai/features/flashcards/presentation/screens/flashcards_screen.dart';
import 'package:padhai/features/topics/presentation/screens/topic_detail_screen.dart';
import 'package:padhai/features/quiz/presentation/screens/quiz_screen.dart';
import 'package:padhai/features/quiz/presentation/screens/quiz_result_screen.dart';
import 'package:padhai/features/bookmarks/presentation/screens/bookmarks_screen.dart';
import 'package:padhai/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:padhai/features/review/presentation/screens/review_screen.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      GoRoute(
        path: AppRoute.splash.path,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoute.onboarding.path,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoute.login.path,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoute.dashboard.path,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoute.subjectDetail.path,
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId'];
          if (subjectId == null) {
            return const _InvalidRouteScreen(message: 'Invalid subject');
          }
          return SubjectDetailScreen(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: AppRoute.chapterDetail.path,
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'];
          if (chapterId == null) {
            return const _InvalidRouteScreen(message: 'Invalid chapter');
          }
          return ChapterDetailScreen(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: AppRoute.studyMaterials.path,
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'];
          final chapterName = state.uri.queryParameters['name'] ?? 'Study Materials';
          if (chapterId == null) {
            return const _InvalidRouteScreen(message: 'Invalid chapter');
          }
          return StudyMaterialsScreen(
            chapterId: chapterId,
            chapterName: chapterName,
          );
        },
      ),
      GoRoute(
        path: AppRoute.practiceMode.path,
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'];
          final chapterName = state.uri.queryParameters['name'] ?? 'Practice Mode';
          if (chapterId == null) {
            return const _InvalidRouteScreen(message: 'Invalid chapter');
          }
          return PracticeModeScreen(
            chapterId: chapterId,
            chapterName: chapterName,
          );
        },
      ),
      GoRoute(
        path: AppRoute.topicDetail.path,
        builder: (context, state) {
          final topicId = state.pathParameters['topicId'];
          if (topicId == null) {
            return const _InvalidRouteScreen(message: 'Invalid topic');
          }
          return TopicDetailScreen(topicId: topicId);
        },
      ),
      GoRoute(
        path: AppRoute.quiz.path,
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId'];
          if (chapterId == null) {
            return const _InvalidRouteScreen(message: 'Invalid quiz');
          }
          return QuizScreen(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: AppRoute.quizResult.path,
        builder: (context, state) {
          final attemptId = state.pathParameters['attemptId'];
          if (attemptId == null) {
            return const _InvalidRouteScreen(message: 'Invalid result');
          }
          return QuizResultScreen(attemptId: attemptId);
        },
      ),
      GoRoute(
        path: AppRoute.bookmarks.path,
        builder: (context, state) => const BookmarksScreen(),
      ),
      GoRoute(
        path: AppRoute.analytics.path,
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: AppRoute.review.path,
        builder: (context, state) => const ReviewScreen(),
      ),
      GoRoute(
        path: '/topic/:topicId/flashcards',
        builder: (context, state) {
          final topicId = state.pathParameters['topicId'];
          final topicName = state.uri.queryParameters['name'] ?? 'Flashcards';
          if (topicId == null) {
            return const _InvalidRouteScreen(message: 'Invalid topic');
          }
          return FlashcardsScreen(
            topicId: topicId,
            topicName: topicName,
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}

/// Widget shown when route parameters are invalid
class _InvalidRouteScreen extends StatelessWidget {
  final String message;

  const _InvalidRouteScreen({required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.dashboard.path),
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
