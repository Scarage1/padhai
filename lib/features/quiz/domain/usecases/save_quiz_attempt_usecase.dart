// lib/features/quiz/domain/usecases/save_quiz_attempt_usecase.dart
import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';
import 'package:uuid/uuid.dart';

@injectable
class SaveQuizAttemptUseCase {
  final AppDatabase _database;
  final _uuid = const Uuid();

  SaveQuizAttemptUseCase(this._database);

  Future<Either<Failure, String>> call({
    required String userId,
    required String chapterId,
    required List<String> questionIds,
    required List<String> userAnswers,
    required List<bool> isCorrectList,
    required DateTime startedAt,
    required DateTime completedAt,
  }) async {
    try {
      final attemptId = _uuid.v4();

      // Calculate score
      final correctCount = isCorrectList.where((c) => c).length;
      final scorePercentage = (correctCount / questionIds.length) * 100;

      // Save quiz attempt
      await _database.quizDao.insertQuizAttempt(
        QuizAttemptsCompanion.insert(
          id: attemptId,
          userId: userId,
          chapterId: chapterId,
          totalQuestions: questionIds.length,
          correctAnswers: correctCount,
          score: scorePercentage.toInt(),
          maxScore: 100,
          difficulty: 'beginner',
          startedAt: startedAt,
          completedAt: Value(completedAt),
        ),
      );

      // Save individual answers
      for (int i = 0; i < questionIds.length; i++) {
        await _database.quizDao.insertUserAnswer(
          UserAnswersCompanion.insert(
            id: _uuid.v4(),
            attemptId: attemptId,
            questionId: questionIds[i],
            selectedAnswer: userAnswers[i],
            isCorrect: isCorrectList[i],
            timeSpentSeconds: 30, // Default 30 seconds per question
            answeredAt: DateTime.now(),
          ),
        );
      }

      // Update user difficulty based on score
      if (scorePercentage >= 90) {
        await _updateUserDifficulty(userId, chapterId, 'advanced');
      } else if (scorePercentage >= 80) {
        await _updateUserDifficulty(userId, chapterId, 'intermediate');
      }

      return Right(attemptId);
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }

  Future<void> _updateUserDifficulty(
    String userId,
    String chapterId,
    String newDifficulty,
  ) async {
    try {
      // Get chapter's subject
      final chapter = await _database.chaptersDao.getChapterById(chapterId);
      if (chapter == null) return;

      await _database.progressDao.upsertUserDifficulty(
        UserDifficultyCompanion.insert(
          id: _uuid.v4(),
          userId: userId,
          subjectId: chapter.subjectId,
          difficultyLevel: newDifficulty,
          lastUpdatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      // Ignore difficulty update errors
    }
  }
}
