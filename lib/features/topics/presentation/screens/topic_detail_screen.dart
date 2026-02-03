// lib/features/topics/presentation/screens/topic_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/topics/presentation/providers/topic_detail_provider.dart';
import 'package:padhai/shared/widgets/app_button.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';

class TopicDetailScreen extends ConsumerStatefulWidget {
  final String topicId;

  const TopicDetailScreen({
    super.key,
    required this.topicId,
  });

  @override
  ConsumerState<TopicDetailScreen> createState() => _TopicDetailScreenState();
}

class _TopicDetailScreenState extends ConsumerState<TopicDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(topicDetailProvider(widget.topicId).notifier).loadTopicDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(topicDetailProvider(widget.topicId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(state.topic?.title ?? 'Topic'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.isLoading && state.topic == null
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.topic == null
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () {
                    ref
                        .read(topicDetailProvider(widget.topicId).notifier)
                        .loadTopicDetail();
                  },
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Completion status
                      if (state.progress?.isCompleted == true)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppSpacing.sm),
                            border: Border.all(
                              color: AppColors.success.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Text(
                                'Completed',
                                style: AppTypography.bodyMedium.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(height: AppSpacing.lg),

                      // Topic description
                      Text(
                        state.topic?.content ?? '',
                        style: AppTypography.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // Video section (placeholder)
                      _buildVideoSection(null),
                      const SizedBox(height: AppSpacing.xl),

                      // Content section
                      _buildContentSection(state.topic?.content ?? ''),
                      const SizedBox(height: AppSpacing.xl),

                      // Key concepts
                      if (state.topic != null) ...[
                        Text(
                          'Key Concepts',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _buildKeyConceptsCard(),
                        const SizedBox(height: AppSpacing.xl),
                      ],

                      // Action buttons
                      if (state.progress?.isCompleted != true)
                        AppButton(
                          label: 'Mark as Completed',
                          onPressed: () {
                            ref
                                .read(topicDetailProvider(widget.topicId)
                                    .notifier)
                                .markAsCompleted();
                          },
                          variant: AppButtonVariant.secondary,
                        ),
                      const SizedBox(height: AppSpacing.md),
                      AppButton(
                        label: 'Start Practice Quiz',
                        onPressed: () {
                          if (state.topic != null) {
                            context.push(
                              AppRoute.quiz.path.replaceAll(
                                ':chapterId',
                                state.topic!.chapterId,
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.quiz),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildVideoSection(String? videoUrl) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.textTertiary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.md),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 64,
                color: AppColors.primary,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Video Content',
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                videoUrl ?? 'Coming Soon',
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContentSection(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Learning Material',
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.md),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Text(
              content.isNotEmpty
                  ? content
                  : 'This topic covers fundamental concepts and principles. Study the material carefully and practice with the quiz to test your understanding.',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.6,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeyConceptsCard() {
    final concepts = [
      'Understand the fundamental principles',
      'Apply concepts to solve problems',
      'Relate to real-world applications',
      'Practice with varied difficulty levels',
    ];

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: concepts
              .map(
                (concept) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.check_circle_outline,
                        size: 20,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          concept,
                          style: AppTypography.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
