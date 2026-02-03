// lib/features/subjects/presentation/widgets/chapter_card.dart
import 'package:flutter/material.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/subjects/domain/entities/chapter_with_progress.dart';

class ChapterCard extends StatelessWidget {
  final ChapterWithProgress chapterWithProgress;
  final VoidCallback onTap;

  const ChapterCard({
    super.key,
    required this.chapterWithProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chapter = chapterWithProgress.chapter;
    final isLocked = !chapterWithProgress.isUnlocked;
    final progress = chapterWithProgress.progressPercentage;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: InkWell(
        onTap: isLocked ? null : onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Stack(
          children: [
            // Main content
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Chapter number and lock icon
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isLocked
                              ? AppColors.textTertiary.withOpacity(0.2)
                              : AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${chapter.chapterNumber}',
                            style: AppTypography.h3.copyWith(
                              color: isLocked
                                  ? AppColors.textTertiary
                                  : AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isLocked)
                        Icon(
                          Icons.lock,
                          color: AppColors.textTertiary,
                          size: 20,
                        )
                      else if (chapterWithProgress.isCompleted)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Chapter title
                  Text(
                    chapter.title,
                    style: AppTypography.h3.copyWith(
                      color: isLocked
                          ? AppColors.textTertiary
                          : AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Chapter description
                  Text(
                    chapter.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isLocked
                          ? AppColors.textTertiary
                          : AppColors.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Progress bar
                  if (!isLocked) ...[
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.xs),
                            child: LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: AppColors.primaryLight,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                chapterWithProgress.isCompleted
                                    ? AppColors.success
                                    : AppColors.primary,
                              ),
                              minHeight: 6,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Text(
                          '${progress.toInt()}%',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${chapterWithProgress.completedTopics}/${chapterWithProgress.totalTopics} topics completed',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ] else
                    Text(
                      'Complete previous chapter to unlock',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),

            // Locked overlay
            if (isLocked)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(AppSpacing.md),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
