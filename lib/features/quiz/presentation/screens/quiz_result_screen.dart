// lib/features/quiz/presentation/screens/quiz_result_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/di/injection.dart';
import 'package:padhai/shared/widgets/app_button.dart';

class QuizResultScreen extends ConsumerStatefulWidget {
  final String attemptId;

  const QuizResultScreen({
    super.key,
    required this.attemptId,
  });

  @override
  ConsumerState<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends ConsumerState<QuizResultScreen> {
  QuizAttempt? _attempt;
  // ignore: unused_field - Reserved for future detailed answers display
  List<UserAnswer> _answers = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  Future<void> _loadResults() async {
    try {
      final database = getIt<AppDatabase>();
      final attempt = await database.quizDao.getQuizAttemptById(widget.attemptId);
      final answers = await database.quizDao.getUserAnswersByAttempt(widget.attemptId);

      if (!mounted) return;
      setState(() {
        _attempt = attempt;
        _answers = answers;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Failed to load quiz results: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _error = 'Failed to load results: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_attempt == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                _error ?? 'Quiz results not found',
                style: AppTypography.h3.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButton(
                label: 'Back to Dashboard',
                onPressed: () => context.go(AppRoute.dashboard.path),
              ),
            ],
          ),
        ),
      );
    }

    // Capture attempt in local variable for null safety
    final attempt = _attempt!;
    final score = attempt.score.toDouble();
    final isPassed = score >= 60;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Quiz Results'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            // Score card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.lg),
              ),
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isPassed
                        ? [AppColors.success, AppColors.success.withOpacity(0.8)]
                        : [AppColors.warning, AppColors.warning.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppSpacing.lg),
                ),
                child: Column(
                  children: [
                    Icon(
                      isPassed ? Icons.celebration : Icons.sentiment_neutral,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isPassed ? 'Great Job!' : 'Keep Practicing!',
                      style: AppTypography.h2.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Your Score',
                      style: AppTypography.bodyLarge.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${score.toInt()}%',
                      style: AppTypography.h1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 56,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    '${attempt.totalQuestions}',
                    Icons.quiz,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    'Correct',
                    '${attempt.correctAnswers}',
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatCard(
                    'Wrong',
                    '${attempt.totalQuestions - attempt.correctAnswers}',
                    Icons.cancel,
                    AppColors.error,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // Performance message
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Icon(
                      isPassed ? Icons.thumb_up : Icons.lightbulb_outline,
                      color: isPassed ? AppColors.success : AppColors.warning,
                      size: 32,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      isPassed
                          ? 'Excellent work! You\'ve mastered this chapter.'
                          : 'Don\'t worry! Review the material and try again.',
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Action buttons
            AppButton(
              label: 'Back to Dashboard',
              onPressed: () => context.go(AppRoute.dashboard.path),
              variant: AppButtonVariant.secondary,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Review Answers',
              onPressed: () => context.go(AppRoute.review.path),
              icon: const Icon(Icons.visibility),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: AppTypography.h2.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.xs / 2),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
