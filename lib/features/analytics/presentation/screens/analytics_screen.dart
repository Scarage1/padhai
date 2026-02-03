import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// AppBar import removed - using standard AppBar
import 'package:padhai/app/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/user_analytics.dart';
import '../providers/analytics_provider.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = ref.read(authProvider).user?.id;
      if (userId != null) {
        ref.read(analyticsProvider(userId).notifier).loadAnalytics();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Not logged in')),
      );
    }

    final analyticsState = ref.watch(analyticsProvider(user.id));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        automaticallyImplyLeading: true,
      ),
      body: analyticsState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : analyticsState.errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        analyticsState.errorMessage!,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : analyticsState.analytics == null
                  ? const Center(child: Text('No analytics available'))
                  : _buildAnalyticsContent(analyticsState.analytics!),
    );
  }

  Widget _buildAnalyticsContent(UserAnalytics analytics) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Overview Cards
        _buildOverviewSection(analytics),
        const SizedBox(height: 24),

        // Subject Performance
        _buildSectionHeader('Subject Performance'),
        const SizedBox(height: 12),
        ...analytics.subjectAnalytics.map((subject) => _buildSubjectCard(subject)),
        const SizedBox(height: 24),

        // Recent Quizzes
        _buildSectionHeader('Recent Quizzes'),
        const SizedBox(height: 12),
        ...analytics.recentQuizzes.map((quiz) => _buildQuizCard(quiz)),
      ],
    );
  }

  Widget _buildOverviewSection(UserAnalytics analytics) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Quizzes',
            analytics.totalQuizzes.toString(),
            Icons.quiz,
            AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            'Avg Score',
            '${analytics.averageScore}%',
            Icons.trending_up,
            Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildSubjectCard(SubjectAnalytics subject) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    subject.subjectName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  '${subject.averageScore}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: subject.averageScore >= 60
                        ? Colors.green
                        : Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.quiz, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${subject.totalQuizzes} quizzes',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.book, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  '${subject.completedChapters}/${subject.totalChapters} chapters',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            if (subject.totalChapters > 0) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: subject.progressPercentage / 100,
                backgroundColor: Colors.grey[200],
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildQuizCard(QuizPerformance quiz) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: quiz.score >= 60 ? Colors.green[50] : Colors.orange[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  '${quiz.score}%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: quiz.score >= 60 ? Colors.green : Colors.orange,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quiz.chapterName,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${quiz.correctAnswers}/${quiz.totalQuestions} correct',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              _formatDate(quiz.completedAt),
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}';
    }
  }
}
