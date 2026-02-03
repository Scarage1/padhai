// lib/features/flashcards/presentation/screens/flashcards_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/core/database/models/flashcard.dart';
import 'package:padhai/features/flashcards/presentation/providers/flashcards_provider.dart';
import 'package:padhai/shared/widgets/app_button.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';

class FlashcardsScreen extends ConsumerStatefulWidget {
  final int topicId;
  final String topicName;

  const FlashcardsScreen({
    super.key,
    required this.topicId,
    required this.topicName,
  });

  @override
  ConsumerState<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends ConsumerState<FlashcardsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _flipController;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(flashcardSessionProvider(widget.topicId).notifier)
          .loadFlashcards();
    });
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(flashcardSessionProvider(widget.topicId));

    // Watch for flip state changes
    ref.listen(flashcardSessionProvider(widget.topicId), (previous, next) {
      if (previous?.isFlipped != next.isFlipped) {
        if (next.isFlipped) {
          _flipController.forward();
        } else {
          _flipController.reverse();
        }
      }
    });

    if (state.isCompleted) {
      return _FlashcardCompletedScreen(
        topicId: widget.topicId,
        topicName: widget.topicName,
        totalCards: state.flashcards.length,
        correctCount: state.correctCount,
        incorrectCount: state.incorrectCount,
        accuracy: state.accuracy,
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Flashcards - ${widget.topicName}'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showHelpDialog(context),
          ),
        ],
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.error != null
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () {
                    ref
                        .read(flashcardSessionProvider(widget.topicId).notifier)
                        .loadFlashcards();
                  },
                )
              : Column(
                  children: [
                    _buildProgressBar(state),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: _buildFlashcard(state),
                        ),
                      ),
                    ),
                    _buildControlButtons(state),
                  ],
                ),
    );
  }

  Widget _buildProgressBar(FlashcardSessionState state) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      color: AppColors.surface,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Card ${state.currentCardIndex + 1}/${state.flashcards.length}',
                style: AppTypography.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Mastery: ${state.currentCard?.masteryLevel ?? 0}/5',
                style: AppTypography.caption.copyWith(
                  color: _getMasteryColor(state.currentCard?.masteryLevel ?? 0),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          LinearProgressIndicator(
            value: state.progress,
            backgroundColor: AppColors.border,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcard(FlashcardSessionState state) {
    final card = state.currentCard;
    if (card == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        ref.read(flashcardSessionProvider(widget.topicId).notifier).flipCard();
      },
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final angle = _flipAnimation.value * math.pi;
          final isBack = angle > math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildCardBack(card),
                  )
                : _buildCardFront(card),
          );
        },
      ),
    );
  }

  Widget _buildCardFront(Flashcard card) {
    return _buildCardContainer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Term',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            card.term,
            style: AppTypography.h2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Icon(
            Icons.touch_app,
            color: AppColors.textSecondary.withOpacity(0.5),
            size: 32,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Tap to reveal definition',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardBack(Flashcard card) {
    return _buildCardContainer(
      backgroundColor: AppColors.primary.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Definition',
            style: AppTypography.caption.copyWith(
              color: AppColors.primary,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            card.definition,
            style: AppTypography.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            'Did you know it?',
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({
    required Widget child,
    Color? backgroundColor,
  }) {
    return Card(
      elevation: 8,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        width: double.infinity,
        height: 400,
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: child,
      ),
    );
  }

  Widget _buildControlButtons(FlashcardSessionState state) {
    if (!state.isFlipped) {
      return Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: AppButton(
          text: 'Flip Card',
          onPressed: () {
            ref.read(flashcardSessionProvider(widget.topicId).notifier).flipCard();
          },
          isFullWidth: true,
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
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
          Expanded(
            child: AppButton(
              text: 'Didn\'t Know',
              onPressed: () {
                ref
                    .read(flashcardSessionProvider(widget.topicId).notifier)
                    .markAsIncorrect();
              },
              variant: AppButtonVariant.secondary,
              icon: Icons.close,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: AppButton(
              text: 'Got It!',
              onPressed: () {
                ref
                    .read(flashcardSessionProvider(widget.topicId).notifier)
                    .markAsCorrect();
              },
              icon: Icons.check,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMasteryColor(int masteryLevel) {
    if (masteryLevel >= 5) return AppColors.success;
    if (masteryLevel >= 3) return AppColors.primary;
    if (masteryLevel >= 1) return AppColors.warning;
    return AppColors.error;
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How to Use Flashcards'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHelpItem(
              '1. Read the term',
              'Try to recall the definition',
            ),
            _buildHelpItem(
              '2. Flip the card',
              'Tap anywhere to reveal the answer',
            ),
            _buildHelpItem(
              '3. Rate yourself',
              'Mark if you knew it or not',
            ),
            _buildHelpItem(
              '4. Spaced repetition',
              'Cards you struggle with appear more often',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            description,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _FlashcardCompletedScreen extends StatelessWidget {
  final int topicId;
  final String topicName;
  final int totalCards;
  final int correctCount;
  final int incorrectCount;
  final double accuracy;

  const _FlashcardCompletedScreen({
    required this.topicId,
    required this.topicName,
    required this.totalCards,
    required this.correctCount,
    required this.incorrectCount,
    required this.accuracy,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Session Complete'),
        backgroundColor: AppColors.primary,
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
                Icons.star,
                size: 100,
                color: AppColors.warning,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Excellent Work!',
                style: AppTypography.h1.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'You reviewed $totalCards flashcards',
                style: AppTypography.h3,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      _buildStatRow('Total Cards', totalCards.toString()),
                      const Divider(),
                      _buildStatRow(
                        'Got It Right',
                        correctCount.toString(),
                        color: AppColors.success,
                      ),
                      const Divider(),
                      _buildStatRow(
                        'Need More Practice',
                        incorrectCount.toString(),
                        color: AppColors.error,
                      ),
                      const Divider(),
                      _buildStatRow(
                        'Accuracy',
                        '${accuracy.toStringAsFixed(1)}%',
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              Consumer(
                builder: (context, ref, child) {
                  return Column(
                    children: [
                      AppButton(
                        text: 'Review Again',
                        onPressed: () {
                          ref
                              .read(flashcardSessionProvider(topicId).notifier)
                              .restartSession();
                        },
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        text: 'Back to Topic',
                        onPressed: () => context.pop(),
                        variant: AppButtonVariant.secondary,
                        isFullWidth: true,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyLarge),
          Text(
            value,
            style: AppTypography.h3.copyWith(
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
