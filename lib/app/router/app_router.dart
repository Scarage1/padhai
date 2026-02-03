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
          final subjectId = state.pathParameters['subjectId']!;
          return SubjectDetailScreen(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: AppRoute.chapterDetail.path,
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return ChapterDetailScreen(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: AppRoute.topicDetail.path,
        builder: (context, state) {
          final topicId = state.pathParameters['topicId']!;
          return TopicDetailScreen(topicId: topicId);
        },
      ),
      GoRoute(
        path: AppRoute.quiz.path,
        builder: (context, state) {
          final chapterId = state.pathParameters['chapterId']!;
          return QuizScreen(chapterId: chapterId);
        },
      ),
      GoRoute(
        path: AppRoute.quizResult.path,
        builder: (context, state) {
          final attemptId = state.pathParameters['attemptId']!;
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
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
