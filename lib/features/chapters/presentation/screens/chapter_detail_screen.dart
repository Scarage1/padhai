// lib/features/chapters/presentation/screens/chapter_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/chapters/presentation/providers/chapter_detail_provider.dart';
import 'package:padhai/features/chapters/presentation/widgets/topic_card.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';
import 'package:padhai/shared/widgets/app_loading.dart';

class ChapterDetailScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ChapterDetailScreen({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<ChapterDetailScreen> createState() =>
      _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends ConsumerState<ChapterDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(chapterDetailProvider(widget.chapterId).notifier)
          .loadChapterDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chapterDetailProvider(widget.chapterId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(state.chapter?.name ?? 'Chapter'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.isLoading && state.topics.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.topics.isEmpty
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () {
                    ref
                        .read(chapterDetailProvider(widget.chapterId).notifier)
                        .loadChapterDetail();
                  },
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(chapterDetailProvider(widget.chapterId).notifier)
                        .loadChapterDetail();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter header
                        if (state.chapter != null) ...[
                          Text(
                            state.chapter!.description,
                            style: AppTypography.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],

                        // Progress summary
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppSpacing.md),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    'Total Topics',
                                    '${state.topics.length}',
                                    Icons.topic,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: AppColors.border,
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Completed',
                                    '${state.topics.where((t) => t.isCompleted).length}',
                                    Icons.check_circle,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: AppColors.border,
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Remaining',
                                    '${state.topics.where((t) => !t.isCompleted).length}',
                                    Icons.pending,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Topics section
                        Text(
                          'Topics',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Topics list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.topics.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.sm),
                          itemBuilder: (context, index) {
                            final topicWithProgress = state.topics[index];
                            return TopicCard(
                              topicWithProgress: topicWithProgress,
                              onTap: () {
                                context.push(
                                  AppRoute.topicDetail.path.replaceAll(
                                    ':topicId',
                                    topicWithProgress.topic.id,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: AppTypography.h3.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
