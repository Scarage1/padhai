// lib/features/dashboard/domain/usecases/get_user_stats_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:padhai/features/dashboard/domain/entities/user_stats.dart';

@injectable
class GetUserStatsUseCase {
  final AppDatabase _database;

  GetUserStatsUseCase(this._database);

  Future<Either<Failure, UserStats>> call(String userId) async {
    try {
      // Get total topics completed
      final totalTopicsCompleted = await _database.progressDao
          .getCompletedTopicsCountForUser(userId);

      // Get total quiz attempts
      final totalQuizAttempts =
          await _database.quizDao.getAttemptCountForUser(userId);

      // Get user info for streak
      final user = await _database.usersDao.getUserById(userId);
      final streakDays = user?.streakDays ?? 0;

      // Calculate average score from quiz attempts
      final attempts = await _database.quizDao.getAttemptsByUserId(userId);
      double averageScore = 0.0;
      if (attempts.isNotEmpty) {
        final totalScore = attempts.fold<int>(
          0,
          (sum, attempt) => sum + attempt.score,
        );
        averageScore = totalScore / attempts.length;
      }

      return Right(UserStats(
        totalTopicsCompleted: totalTopicsCompleted,
        totalQuizAttempts: totalQuizAttempts,
        streakDays: streakDays,
        averageScore: averageScore,
      ));
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
