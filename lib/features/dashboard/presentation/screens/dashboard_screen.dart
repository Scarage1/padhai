// lib/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:padhai/app/router/routes.dart';
import 'package:padhai/app/theme/app_colors.dart';
import 'package:padhai/app/theme/app_spacing.dart';
import 'package:padhai/app/theme/app_typography.dart';
import 'package:padhai/features/auth/presentation/providers/auth_provider.dart';
import 'package:padhai/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:padhai/features/dashboard/presentation/widgets/stats_card.dart';
import 'package:padhai/features/dashboard/presentation/widgets/subject_card.dart';
import 'package:padhai/shared/widgets/app_error_widget.dart';
import 'package:padhai/shared/widgets/app_loading.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).loadDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              // TODO: Navigate to profile
            },
          ),
        ],
      ),
      body: state.isLoading && state.subjects.isEmpty
          ? const AppLoading()
          : state.error != null && state.subjects.isEmpty
              ? AppErrorWidget(
                  message: state.error!,
                  onRetry: () {
                    ref.read(dashboardProvider.notifier).loadDashboardData();
                  },
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(dashboardProvider.notifier)
                        .loadDashboardData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome message
                        Text(
                          'Welcome back, ${authState.user?.name ?? 'Student'}!',
                          style: AppTypography.h2.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Let\'s continue your learning journey',
                          style: AppTypography.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xl),

                        // Stats section
                        if (state.userStats != null) ...[
                          Text(
                            'Your Progress',
                            style: AppTypography.h3.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          GridView.count(
                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 1.3,
                            children: [
                              StatsCard(
                                title: 'Topics Completed',
                                value: '${state.userStats!.totalTopicsCompleted}',
                                icon: Icons.check_circle,
                                color: AppColors.success,
                              ),
                              StatsCard(
                                title: 'Quiz Attempts',
                                value: '${state.userStats!.totalQuizAttempts}',
                                icon: Icons.quiz,
                                color: AppColors.primary,
                              ),
                              StatsCard(
                                title: 'Streak Days',
                                value: '${state.userStats!.streakDays}',
                                icon: Icons.local_fire_department,
                                color: AppColors.warning,
                              ),
                              StatsCard(
                                title: 'Avg. Score',
                                value: '${state.userStats!.averageScore.toStringAsFixed(0)}%',
                                icon: Icons.trending_up,
                                color: AppColors.info,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],

                        // Subjects section
                        Text(
                          'Choose a Subject',
                          style: AppTypography.h3.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: state.subjects.length,
                          itemBuilder: (context, index) {
                            final subject = state.subjects[index];
                            return SubjectCard(
                              subject: subject,
                              onTap: () {
                                context.push(
                                  AppRoute.subjectDetail.path.replaceAll(
                                    ':subjectId',
                                    subject.id,
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
}
