// Analytics summary for user
class UserAnalytics {
  final int totalQuizzes;
  final int averageScore;
  final int totalTopicsCompleted;
  final int streakDays;
  final List<SubjectAnalytics> subjectAnalytics;
  final List<QuizPerformance> recentQuizzes;

  const UserAnalytics({
    required this.totalQuizzes,
    required this.averageScore,
    required this.totalTopicsCompleted,
    required this.streakDays,
    required this.subjectAnalytics,
    required this.recentQuizzes,
  });
}

// Subject-wise analytics
class SubjectAnalytics {
  final String subjectId;
  final String subjectName;
  final int totalChapters;
  final int completedChapters;
  final int averageScore;
  final int totalQuizzes;

  const SubjectAnalytics({
    required this.subjectId,
    required this.subjectName,
    required this.totalChapters,
    required this.completedChapters,
    required this.averageScore,
    required this.totalQuizzes,
  });

  double get progressPercentage {
    if (totalChapters == 0) return 0;
    return (completedChapters / totalChapters) * 100;
  }
}

// Individual quiz performance
class QuizPerformance {
  final int attemptId;
  final String chapterName;
  final String subjectName;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;

  const QuizPerformance({
    required this.attemptId,
    required this.chapterName,
    required this.subjectName,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
  });
}
