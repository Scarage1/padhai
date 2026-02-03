import 'package:fpdart/fpdart.dart';
import '../../../../core/database/daos/quiz_dao.dart';
import '../../../../core/database/daos/progress_dao.dart';
import '../../../../core/database/daos/users_dao.dart';
import '../../../../core/database/daos/subjects_dao.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_analytics.dart';

// Use case to get comprehensive analytics for a user
class GetUserAnalyticsUseCase {
  final QuizDao _quizDao;
  final ProgressDao _progressDao;
  final UsersDao _usersDao;
  final SubjectsDao _subjectsDao;

  GetUserAnalyticsUseCase({
    required QuizDao quizDao,
    required ProgressDao progressDao,
    required UsersDao usersDao,
    required SubjectsDao subjectsDao,
  })  : _quizDao = quizDao,
        _progressDao = progressDao,
        _usersDao = usersDao,
        _subjectsDao = subjectsDao;

  Future<Either<Failure, UserAnalytics>> call({
    required String userId,
  }) async {
    try {
      // Get user info
      final user = await _usersDao.getUserById(userId);
      if (user == null) {
        return left(const DatabaseFailure('User not found'));
      }

      // Get quiz attempts with details
      final quizAttempts = await _quizDao.getUserQuizAttempts(userId);
      
      // Calculate total quizzes and average score
      final totalQuizzes = quizAttempts.length;
      final averageScore = totalQuizzes > 0
          ? (quizAttempts.fold<int>(0, (sum, attempt) => sum + attempt.score) /
                  totalQuizzes)
              .round()
          : 0;

      // Get completed topics count
      final completedTopics = await _progressDao.getCompletedTopicsCountForUser(userId);

      // Get subject-wise analytics
      final subjects = await _subjectsDao.getAllSubjects();
      final subjectAnalytics = await Future.wait(
        subjects.map((subject) => _getSubjectAnalytics(userId, subject.id, subject.name)),
      );

      // Get recent quiz performances (last 10)
      final recentQuizzes = quizAttempts
          .take(10)
          .map((attempt) => QuizPerformance(
                attemptId: attempt.id.hashCode,
                chapterName: 'Chapter', // Will be populated with join
                subjectName: 'Subject', // Will be populated with join
                score: attempt.score,
                totalQuestions: attempt.totalQuestions,
                correctAnswers: attempt.correctAnswers,
                completedAt: attempt.completedAt ?? DateTime.now(),
              ))
          .toList();

      return right(UserAnalytics(
        totalQuizzes: totalQuizzes,
        averageScore: averageScore,
        totalTopicsCompleted: completedTopics,
        streakDays: user.streakDays,
        subjectAnalytics: subjectAnalytics,
        recentQuizzes: recentQuizzes,
      ));
    } catch (e) {
      return left(DatabaseFailure('Failed to fetch analytics: ${e.toString()}'));
    }
  }

  Future<SubjectAnalytics> _getSubjectAnalytics(
    String userId,
    String subjectId,
    String subjectName,
  ) async {
    // Get all quiz attempts for user
    final allAttempts = await _quizDao.getUserQuizAttempts(userId);
    
    // Filter by subject (simplified - would need join for accurate filtering)
    final totalQuizzes = allAttempts.length;
    final averageScore = totalQuizzes > 0
        ? (allAttempts.fold<int>(0, (sum, attempt) => sum + attempt.score) /
                totalQuizzes)
            .round()
        : 0;

    return SubjectAnalytics(
      subjectId: subjectId,
      subjectName: subjectName,
      totalChapters: 0, // Would need chapters count query
      completedChapters: 0, // Would need chapter progress query
      averageScore: averageScore,
      totalQuizzes: totalQuizzes,
    );
  }
}
