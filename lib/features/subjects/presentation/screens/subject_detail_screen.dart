// lib/features/subjects/presentation/screens/subject_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/subjects/presentation/providers/subject_detail_provider.dart';
import 'package:padhai/features/subjects/presentation/widgets/chapter_card.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';

class SubjectDetailScreen extends ConsumerStatefulWidget {
  final String subjectId;

  const SubjectDetailScreen({
    super.key,
    required this.subjectId,
  });

  @override
  ConsumerState<SubjectDetailScreen> createState() =>
      _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends ConsumerState<SubjectDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(subjectDetailProvider(widget.subjectId).notifier)
          .loadSubjectDetail();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(subjectDetailProvider(widget.subjectId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(state.subject?.name ?? 'Subject'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: state.isLoading && state.chapters.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.error != null && state.chapters.isEmpty
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () {
                    ref
                        .read(subjectDetailProvider(widget.subjectId).notifier)
                        .loadSubjectDetail();
                  },
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(subjectDetailProvider(widget.subjectId).notifier)
                        .loadSubjectDetail();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Subject header
                        if (state.subject != null) ...[
                          Text(
                            state.subject!.description,
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
                                    'Total Chapters',
                                    '${state.chapters.length}',
                                    Icons.book,
                                    AppColors.primary,
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
                                    '${state.chapters.where((c) => c.isCompleted).length}',
                                    Icons.check_circle,
                                    AppColors.success,
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: AppColors.border,
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    'Unlocked',
                                    '${state.chapters.where((c) => c.isUnlocked).length}',
                                    Icons.lock_open,
                                    AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Chapters section
                        Text(
                          'Chapters',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),

                        // Chapters list
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.chapters.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final chapterWithProgress = state.chapters[index];
                            return ChapterCard(
                              chapterWithProgress: chapterWithProgress,
                              onTap: () {
                                context.push(
                                  AppRoute.chapterDetail.path.replaceAll(
                                    ':chapterId',
                                    chapterWithProgress.chapter.id,
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

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
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
