// lib/core/database/daos/quiz_dao.dart
import 'package:drift/drift.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/database/tables/all_tables.dart';

part 'quiz_dao.g.dart';

@DriftAccessor(tables: [QuizAttempts, UserAnswers])
class QuizDao extends DatabaseAccessor<AppDatabase> with _$QuizDaoMixin {
  QuizDao(super.db);

  Future<int> insertQuizAttempt(QuizAttemptsCompanion attempt) {
    return into(quizAttempts).insert(attempt);
  }

  Future<bool> updateQuizAttempt(QuizAttemptsCompanion attempt) {
    return update(quizAttempts).replace(attempt);
  }

  Future<QuizAttempt?> getQuizAttemptById(String id) {
    return (select(quizAttempts)..where((tbl) => tbl.id.equals(id)))
        .getSingleOrNull();
  }

  Future<List<QuizAttempt>> getQuizAttemptsByUser(String userId) {
    return (select(quizAttempts)
          ..where((tbl) => tbl.userId.equals(userId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)]))
        .get();
  }

  Future<List<QuizAttempt>> getQuizAttemptsByChapter(
    String userId,
    String chapterId,
  ) {
    return (select(quizAttempts)
          ..where((tbl) =>
              tbl.userId.equals(userId) & tbl.chapterId.equals(chapterId))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.startedAt)]))
        .get();
  }

  Future<int> insertUserAnswer(UserAnswersCompanion answer) {
    return into(userAnswers).insert(answer);
  }

  Future<List<UserAnswer>> getUserAnswersByAttempt(String attemptId) {
    return (select(userAnswers)..where((tbl) => tbl.attemptId.equals(attemptId)))
        .get();
  }

  Future<int> getAttemptCountForUser(String userId) async {
    final query = selectOnly(quizAttempts)
      ..where(quizAttempts.userId.equals(userId))
      ..addColumns([quizAttempts.id.count()]);

    final result = await query.getSingleOrNull();
    return result?.read(quizAttempts.id.count()) ?? 0;
  }

  Future<List<QuizAttempt>> getAttemptsByUserId(String userId) {
    return (select(quizAttempts)..where((tbl) => tbl.userId.equals(userId)))
        .get();
  }

  // Get user quiz attempts for analytics (all attempts with score)
  Future<List<QuizAttempt>> getUserQuizAttempts(String userId) {
    return (select(quizAttempts)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.isCompleted.equals(true))
          ..orderBy([(tbl) => OrderingTerm.desc(tbl.completedAt)]))
        .get();
  }
}
