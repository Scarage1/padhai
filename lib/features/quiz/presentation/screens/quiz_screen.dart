// lib/features/quiz/presentation/screens/quiz_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/quiz/presentation/providers/quiz_provider.dart';
import 'package:padhai/shared/widgets/app_button.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';

class QuizScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const QuizScreen({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(quizProvider(widget.chapterId).notifier).loadQuiz();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(quizProvider(widget.chapterId));

    // Navigate to results if quiz is submitted
    if (state.attemptId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(
          AppRoute.quizResult.path.replaceAll(
            ':attemptId',
            state.attemptId!,
          ),
        );
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitDialog(context);
        if (shouldPop && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(state.chapter?.name ?? 'Quiz'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () async {
              if (await _showExitDialog(context)) {
                if (context.mounted) context.pop();
              }
            },
          ),
          actions: [
            if (state.remainingSeconds != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs / 2,
                    ),
                    decoration: BoxDecoration(
                      color: state.remainingSeconds! < 60
                          ? AppColors.error.withOpacity(0.2)
                          : AppColors.background.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.timer,
                          size: 18,
                          color: state.remainingSeconds! < 60
                              ? AppColors.error
                              : Colors.white,
                        ),
                        const SizedBox(width: AppSpacing.xs / 2),
                        Text(
                          _formatTime(state.remainingSeconds!),
                          style: AppTypography.bodyMedium.copyWith(
                            color: state.remainingSeconds! < 60
                                ? AppColors.error
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: state.isLoading && state.questions.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : state.error != null && state.questions.isEmpty
                ? AppErrorWidget(
                    message: state.error!,
                    onRetry: () {
                      ref
                          .read(quizProvider(widget.chapterId).notifier)
                          .loadQuiz();
                    },
                  )
                : Column(
                    children: [
                      // Progress bar
                      _buildProgressBar(state),
                      
                      // Question content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: _buildQuestionContent(state),
                        ),
                      ),

                      // Navigation buttons
                      _buildNavigationButtons(state),
                    ],
                  ),
      ),
    );
  }

  Widget _buildProgressBar(QuizState state) {
    final progress = state.questions.isEmpty
        ? 0.0
        : (state.currentQuestionIndex + 1) / state.questions.length;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Question ${state.currentQuestionIndex + 1}/${state.totalQuestions}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${state.answeredCount}/${state.totalQuestions} answered',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.xs),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primaryLight,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionContent(QuizState state) {
    if (state.questions.isEmpty) {
      return const Center(child: Text('No questions available'));
    }

    final question = state.questions[state.currentQuestionIndex];
    final selectedAnswer = state.userAnswers[state.currentQuestionIndex];

    // Parse options from JSON (assuming ["A text", "B text", "C text", "D text"])
    // For now, we'll use placeholder options since schema uses JSON
    final optionsList = ['Option A', 'Option B', 'Option C', 'Option D'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question
        Text(
          question.questionText,
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),

        // Options
        for (int i = 0; i < 4; i++) ...[
          _buildOption(
            String.fromCharCode(65 + i), // A, B, C, D
            optionsList[i],
            selectedAnswer,
          ),
          if (i < 3) const SizedBox(height: AppSpacing.md),
        ],
      ],
    );
  }

  Widget _buildOption(String label, String text, String? selectedAnswer) {
    final isSelected = selectedAnswer == label;

    return InkWell(
      onTap: () {
        ref.read(quizProvider(widget.chapterId).notifier).selectAnswer(label);
      },
      borderRadius: BorderRadius.circular(AppSpacing.md),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withOpacity(0.1)
              : Colors.white,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.background,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTypography.bodyMedium.copyWith(
                    color: isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                text,
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons(QuizState state) {
    final isLastQuestion = state.currentQuestionIndex == state.questions.length - 1;
    final canGoNext = state.userAnswers.containsKey(state.currentQuestionIndex);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          if (state.currentQuestionIndex > 0)
            Expanded(
              child: AppButton(
                label: 'Previous',
                onPressed: () {
                  ref
                      .read(quizProvider(widget.chapterId).notifier)
                      .previousQuestion();
                },
                variant: AppButtonVariant.secondary,
              ),
            ),
          if (state.currentQuestionIndex > 0) const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppButton(
              label: isLastQuestion ? 'Submit Quiz' : 'Next',
              onPressed: canGoNext
                  ? () {
                      if (isLastQuestion) {
                        _showSubmitDialog(context);
                      } else {
                        ref
                            .read(quizProvider(widget.chapterId).notifier)
                            .nextQuestion();
                      }
                    }
                  : null,
              isLoading: state.isSubmitting,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit Quiz?'),
            content: const Text(
              'Are you sure you want to exit? Your progress will be lost.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Exit',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<void> _showSubmitDialog(BuildContext context) async {
    final state = ref.read(quizProvider(widget.chapterId));
    final unansweredCount = state.totalQuestions - state.answeredCount;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit Quiz?'),
        content: Text(
          unansweredCount > 0
              ? 'You have $unansweredCount unanswered questions. Do you want to submit?'
              : 'Are you ready to submit your quiz?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Submit'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(quizProvider(widget.chapterId).notifier).submitQuiz();
    }
  }
}
