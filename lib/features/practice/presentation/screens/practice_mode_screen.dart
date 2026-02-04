// lib/features/practice/presentation/screens/practice_mode_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/practice/presentation/providers/practice_provider.dart';
import 'package:padhai/shared/widgets/app_button.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';


class PracticeModeScreen extends ConsumerStatefulWidget {
  final String chapterId;
  final String chapterName;

  const PracticeModeScreen({
    super.key,
    required this.chapterId,
    required this.chapterName,
  });

  @override
  ConsumerState<PracticeModeScreen> createState() =>
      _PracticeModeScreenState();
}

class _PracticeModeScreenState extends ConsumerState<PracticeModeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(practiceSessionProvider(widget.chapterId).notifier)
          .loadQuestions(count: 10);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(practiceSessionProvider(widget.chapterId));

    if (state.isCompleted) {
      return _PracticeCompletedScreen(
        chapterId: widget.chapterId,
        chapterName: widget.chapterName,
        questionsCount: state.questions.length,
        hintsUsed: state.totalHintsUsed,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Practice - ${widget.chapterName}'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () {
                    ref
                        .read(practiceSessionProvider(widget.chapterId).notifier)
                        .loadQuestions();
                  },
                )
              : Column(
                  children: [
                    _buildProgressBar(state),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildQuestionCard(state),
                            const SizedBox(height: AppSpacing.lg),
                            _buildOptionsSection(state),
                            if (state.currentQuestion?.hint != null) ...[
                              const SizedBox(height: AppSpacing.lg),
                              _buildHintSection(state),
                            ],
                            const SizedBox(height: AppSpacing.lg),
                            _buildExplanationSection(state),
                          ],
                        ),
                      ),
                    ),
                    _buildNavigationBar(state),
                  ],
                ),
    );
  }

  Widget _buildProgressBar(PracticeSessionState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${state.currentQuestionIndex + 1}/${state.questions.length}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.lightbulb_outline,
                      size: 16, color: AppColors.warning),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${state.totalHintsUsed} hints used',
                    style: AppTypography.caption,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(PracticeSessionState state) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs / 2,
              ),
              decoration: BoxDecoration(
                color: _getDifficultyColor(question.difficulty),
                borderRadius: BorderRadius.circular(AppSpacing.xs),
              ),
              child: Text(
                question.difficulty.toUpperCase(),
                style: AppTypography.caption.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              question.questionText,
              style: AppTypography.h3,
            ),
            if (question.imageUrl != null) ...[
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
                child: Image.asset(
                  question.imageUrl!,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: AppColors.surface,
                      child: const Center(
                        child: Icon(Icons.image_not_supported),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsSection(PracticeSessionState state) {
    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final options = (json.decode(question.options) as List).cast<String>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((option) {
        final isSelected = state.selectedAnswer == option;

        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: InkWell(
            onTap: () {
              ref
                  .read(practiceSessionProvider(widget.chapterId).notifier)
                  .selectAnswer(option);
            },
            borderRadius: BorderRadius.circular(AppSpacing.md),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.secondary.withOpacity(0.1)
                    : AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.secondary : AppColors.border,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(AppSpacing.md),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSelected ? AppColors.secondary : Colors.transparent,
                      border: Border.all(
                        color: isSelected ? AppColors.secondary : AppColors.border,
                        width: 2,
                      ),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      option,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHintSection(PracticeSessionState state) {
    final question = state.currentQuestion;
    if (question == null || question.hint == null) return const SizedBox.shrink();

    return Card(
      color: AppColors.warning.withOpacity(0.1),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(color: AppColors.warning),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: state.isHintRevealed
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: AppColors.warning, size: 20),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Hint',
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    question.hint!,
                    style: AppTypography.bodyMedium,
                  ),
                ],
              )
            : Center(
                child: TextButton.icon(
                  onPressed: () {
                    ref
                        .read(practiceSessionProvider(widget.chapterId).notifier)
                        .revealHint();
                  },
                  icon: Icon(Icons.lightbulb_outline, color: AppColors.warning),
                  label: Text(
                    'Show Hint',
                    style: TextStyle(color: AppColors.warning),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildExplanationSection(PracticeSessionState state) {
    if (state.selectedAnswer == null) return const SizedBox.shrink();

    final question = state.currentQuestion;
    if (question == null) return const SizedBox.shrink();

    final isCorrect = state.selectedAnswer == question.correctAnswer;

    return Card(
      color: isCorrect
          ? AppColors.success.withOpacity(0.1)
          : AppColors.error.withOpacity(0.1),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
        side: BorderSide(
          color: isCorrect ? AppColors.success : AppColors.error,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isCorrect ? Icons.check_circle : Icons.cancel,
                  color: isCorrect ? AppColors.success : AppColors.error,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  isCorrect ? 'Correct!' : 'Incorrect',
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isCorrect ? AppColors.success : AppColors.error,
                  ),
                ),
              ],
            ),
            if (!isCorrect) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Correct answer: ${question.correctAnswer}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            const SizedBox(height: AppSpacing.sm),
            Text(
              question.explanation,
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationBar(PracticeSessionState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (state.currentQuestionIndex > 0)
            Expanded(
              child: AppButton(
                label: 'Previous',
                onPressed: () {
                  ref
                      .read(practiceSessionProvider(widget.chapterId).notifier)
                      .previousQuestion();
                },
                variant: AppButtonVariant.secondary,
              ),
            ),
          if (state.currentQuestionIndex > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            flex: 2,
            child: AppButton(
              label: state.isLastQuestion ? 'Finish Practice' : 'Next',
              onPressed: state.canProceed
                  ? () async {
                      if (state.isLastQuestion) {
                        // TODO: Get actual user ID
                        await ref
                            .read(practiceSessionProvider(widget.chapterId).notifier)
                            .completePractice('USR_001');
                      } else {
                        ref
                            .read(practiceSessionProvider(widget.chapterId).notifier)
                            .nextQuestion();
                      }
                    }
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'beginner':
        return AppColors.success;
      case 'intermediate':
        return AppColors.warning;
      case 'advanced':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }
}

class _PracticeCompletedScreen extends StatelessWidget {
  final int chapterId;
  final String chapterName;
  final int questionsCount;
  final int hintsUsed;

  const _PracticeCompletedScreen({
    required this.chapterId,
    required this.chapterName,
    required this.questionsCount,
    required this.hintsUsed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Practice Complete'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_outline,
                size: 100,
                color: AppColors.success,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Great Job!',
                style: AppTypography.h1.copyWith(
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'You completed $questionsCount practice questions',
                style: AppTypography.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildStatRow('Questions Attempted', questionsCount.toString()),
                      const Divider(),
                      _buildStatRow('Hints Used', hintsUsed.toString()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              AppButton(
                label: 'Back to Chapter',
                onPressed: () => context.pop(),
                fullWidth: true,
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: 'Practice Again',
                onPressed: () {
                  // Restart practice
                  context.pop();
                  context.push('/chapter/$chapterId/practice?name=$chapterName');
                },
                variant: AppButtonVariant.secondary,
                fullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyLarge),
          Text(
            value,
            style: AppTypography.h3.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}
