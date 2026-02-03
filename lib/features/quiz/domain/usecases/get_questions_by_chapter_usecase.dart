// lib/features/quiz/domain/usecases/get_questions_by_chapter_usecase.dart
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:padhai/core/database/app_database.dart';
import 'package:padhai/core/error/failures.dart';

@injectable
class GetQuestionsByChapterUseCase {
  final AppDatabase _database;

  GetQuestionsByChapterUseCase(this._database);

  Future<Either<Failure, List<Question>>> call(
    String chapterId,
    String userId, {
    int limit = 10,
  }) async {
    try {
      // Get user's current difficulty level for adaptive questions
      final user = await _database.usersDao.getUserById(userId);
      final userDifficulty = user?.currentDifficulty ?? 'beginner';

      // Get questions matching user difficulty
      final questions = await _database.questionsDao
          .getQuestionsByChapterAndDifficulty(chapterId, userDifficulty);

      // If not enough questions at user level, mix with other difficulties
      if (questions.length < limit) {
        final allQuestions =
            await _database.questionsDao.getQuestionsByChapter(chapterId);
        // Take first 'limit' questions
        return Right(allQuestions.take(limit).toList());
      }

      // Shuffle and take required number
      questions.shuffle();
      return Right(questions.take(limit).toList());
    } catch (e) {
      return Left(DatabaseFailure(e.toString()));
    }
  }
}
