// lib/features/chapters/presentation/widgets/topic_card.dart
import 'package:flutter/material.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/chapters/domain/entities/topic_with_progress.dart';

class TopicCard extends StatelessWidget {
  final TopicWithProgress topicWithProgress;
  final VoidCallback onTap;

  const TopicCard({
    super.key,
    required this.topicWithProgress,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final topic = topicWithProgress.topic;
    final isCompleted = topicWithProgress.isCompleted;

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Status icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? AppColors.success.withOpacity(0.2)
                      : AppColors.primary.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.play_circle_outline,
                  color: isCompleted ? AppColors.success : AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              // Topic info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.xs / 2),
                    Text(
                      topic.description,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (isCompleted && topicWithProgress.lastScore != null) ...[
                      const SizedBox(height: AppSpacing.xs / 2),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            size: 14,
                            color: AppColors.warning,
                          ),
                          const SizedBox(width: AppSpacing.xs / 2),
                          Text(
                            'Score: ${topicWithProgress.lastScore!.toInt()}%',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
